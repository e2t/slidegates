import sys
from math import sin, radians, tan, ceil, pi
from typing import Optional, Tuple
from screw import SCREWS, TrapezoidalScrew, DEFAULT_PITCH, Screw, METRICS, \
    MetricScrew
from math_func import G, min_inertia_moment, diam_by_inertia_moment, fos_calc,\
    diam_circle_by_force_shear
from auma import AUMA_SA, AUMA_SAR, MIN_OPEN_TIME, AUMA_GK, MotorMode, Auma, \
    RightAngleGearbox, TRAMEC_RAC
from slg import SlgKind, Drive, LIMIT_SHEAR_STRESS, Install, MotorControl, \
    THICKNESS
from wedge import WEDGES, Wedge
sys.path.append(f'{sys.path[0]}/..')
from dry.core import Error


RECOMMEND_FOS = 2.35
SPECIFIC_SEALING_COMPRESS_FORCE = 2 * G * 1e2  # m
WEDGES_FRIC_ANGLE = 0.148889947609  # atan(0.15)
SCREW_FRIC_ANGLE = 0.148889947609  # atan(0.15)
SCREW_ELAST = 2.1e11  # Pa
SCREW_MJU = 1.0
TOP_BALK_HEIGHT = 0.2  # m
DELTA_OPEN = 5.0  # N*m
RECOMMEND_SPEED = 45 / 60  # rev/sec
ONE_WEDGE_BOLTS_NUMBER = 4


class AumaError(Error):
    pass


def _wedges_pairs_number(hydr_head: float, frame_width: float,
                         gate_height: float) -> int:

    if hydr_head >= 4.0 and (frame_width >= 1.9 or gate_height >= 1.9):
        return 3
    return 2


def _optimal_frame_height(gate_height: float) -> float:
    return 2 * gate_height + TOP_BALK_HEIGHT


def _minimal_frame_height_for_nodes(gate_height: float) -> float:
    return 2 * gate_height + 0.5


def _hydr_force(frame_width: float, gate_height: float, hydr_head: float,
                liquid_density: float, tilt_angle: float) -> float:
    head_top = hydr_head - gate_height * sin(tilt_angle)
    head_bottom = hydr_head
    return liquid_density * G * (head_top + head_bottom) / 2 * frame_width * \
        gate_height


# old version:
# if kind == SlgKind.flow: result = 0
def _sealing_compress_force(kind: SlgKind, frame_width: float,
                            gate_height: float) -> float:
    if kind == SlgKind.deep:
        horiz_sides = 2
    else:
        horiz_sides = 1
    return ((2 * gate_height + horiz_sides * frame_width) *
            SPECIFIC_SEALING_COMPRESS_FORCE)


def _screw_length(have_nodes_in_frame: bool, gate_height: float,
                  frame_height: float) -> float:
    nut_height = 0.1  # 100 mm
    if have_nodes_in_frame:
        return gate_height + nut_height + 0.05
    return frame_height - gate_height + nut_height


def _min_axial_force(gate_force: float, wedges_angle: float,
                     screws_number: int) -> float:
    return gate_force * tan(wedges_angle + WEDGES_FRIC_ANGLE) / screws_number


def _real_axial_force(torque: float, screw: Screw) -> float:
    return (torque / tan(
        (SCREW_FRIC_ANGLE + screw.thread_angle) * screw.pitch_diam / 2))


def _way(gate_height: float, frame_height: float,
         optimal_frame_height: float) -> float:
    if frame_height >= optimal_frame_height:
        return gate_height
    return frame_height - TOP_BALK_HEIGHT - gate_height


def _screw(min_rod: float) -> Screw:
    try:
        result = next(filter(lambda i: min_rod <= i.minor_diam, SCREWS))
    except StopIteration:
        diam_step = 0.005
        result = TrapezoidalScrew(
            ceil((min_rod + DEFAULT_PITCH) / diam_step) * diam_step)
    return result


def _min_close_moment(min_axial_force: float, screw: Screw) -> float:
    return min_axial_force * tan(SCREW_FRIC_ANGLE + screw.thread_angle) * \
        screw.pitch_diam / 2


def _min_speed(revs: float, open_time: float) -> float:
    speed = revs / open_time
    return max(speed, RECOMMEND_SPEED)


def _auma(required_torque: float, required_speed: float, job_mode: MotorMode,
          kind: SlgKind, screws_number: int) -> Auma:

    if kind == SlgKind.flow:
        aumas: Tuple[Tuple[Auma, ...], ...] = AUMA_SAR[2:]  # from 10.2
    else:
        aumas = AUMA_SA[1:]  # from 07.6
    for typesize in aumas:
        if typesize[0].max_torques[job_mode] < required_torque:
            continue
        result = None
        for i in typesize:
            if i.speed >= required_speed and (i.selflock or screws_number > 1):
                result = i
                if result.speed >= RECOMMEND_SPEED:
                    break
        if result:
            break
    else:
        raise AumaError()
    return result


def auma_temperature_range(auma: Auma, motor_control: Optional[MotorControl]) \
        -> Tuple[float, float]:
    if auma.name[:3] == 'SAR':
        if motor_control is None:
            return (-40, +60)
        elif motor_control == MotorControl.simple:  # AM
            return (-40, +60)
        return (-25, +60)  # AC
    else:  # SA
        if motor_control is None:
            return (-40, +80)
        elif motor_control == MotorControl.simple:  # AM
            return (-40, +70)
        return (-25, +70)  # AC


def _check_screw(axial_force: float, screw_length: float) -> Screw:
    min_screw_inertia_moment = min_inertia_moment(
        axial_force, RECOMMEND_FOS, screw_length, SCREW_ELAST, SCREW_MJU)
    min_screw_minor_diam = diam_by_inertia_moment(min_screw_inertia_moment)
    return _screw(min_screw_minor_diam)


def _nut_axe(axial_force: float) -> float:
    axes_number = 2
    hole_diam = 0.010  # M10 into the axe
    return (4 * axial_force / axes_number / pi / LIMIT_SHEAR_STRESS +
            hole_diam**2)**0.5


def _sleeve_gk(is_screw_pullout: bool) -> str:
    if is_screw_pullout:
        result = 'A'
    else:
        result = 'B1'
    return result


def _sleeve_sa(screws_number: int, is_screw_pullout: bool) -> str:
    if screws_number > 1:
        result = 'B3D'
    else:
        result = _sleeve_gk(is_screw_pullout)
    return result


def _reducer(required_torque: float, is_tramec: bool,
             is_screw_pullout: bool) -> RightAngleGearbox:
    if is_screw_pullout and is_tramec:
        raise Error(
            'Недопустимое сочетание: два выдвижных винта и ручное управление. '
            'Tramec не имеет исполнения с резьбовой втулкой')
    if is_tramec:
        gearboxes: Tuple[RightAngleGearbox, ...] = TRAMEC_RAC
    else:
        gearboxes = AUMA_GK
    try:
        return next(filter(lambda i: required_torque <= i.max_torque,
                           gearboxes))
    except StopIteration:
        raise Error('Failed with calculation gearbox')


def _bolt_by_minor_diam(minor_diam: float, minimal_bolt: float,
                        only_recommend: bool) -> MetricScrew:
    for i in METRICS:
        if i.major_diam < minimal_bolt or (only_recommend and
                                           not i.is_recommend):
            continue
        if i.minor_diam >= minor_diam:
            return i
    raise Error('Failed with calculation _bolt_by_minor_diam')


def _wedge_by_bolt(bolt: MetricScrew) -> Wedge:
    try:
        result = next(filter(lambda i:
                             i.bolt.major_diam >= bolt.major_diam, WEDGES))
    except StopIteration:
        result = WEDGES[-1]
    return result


class Slidegate():
    def __init__(self,
                 frame_width: float,
                 gate_height: float,
                 hydr_head: float,
                 kind: SlgKind,
                 drive: Drive,
                 install: Install,
                 is_frame_closed: bool,
                 have_rack: bool,
                 is_screw_pullout: bool = False,
                 tilt_angle: float = pi / 2,
                 screws_number: int = 1,
                 liquid_density: float = 1000,
                 have_fixed_gate: bool = False,
                 frame_height: Optional[float] = None,
                 have_nodes_in_frame: Optional[bool] = None,
                 wedges_pairs_number: Optional[int] = None,
                 motor_control: Optional[MotorControl] = None,
                 is_left_hand_closing: Optional[bool] = None,
                 way: Optional[float] = None,
                 screw_diam: Optional[float] = None,
                 reducer: Optional[RightAngleGearbox] = None,
                 auma: Optional[Auma] = None,
                 beth_frame_top_and_gate_top: Optional[float] = None) -> None:

        self.frame_width = frame_width
        self.gate_height = gate_height
        self.hydr_head = hydr_head
        self.is_screw_pullout = is_screw_pullout
        self.tilt_angle = tilt_angle
        self.motor_control = motor_control
        self.kind = kind
        self.drive = drive
        self.screws_number = screws_number
        self.liquid_density = liquid_density
        self.install = install
        self.is_frame_closed = is_frame_closed
        self.have_rack = have_rack
        self.have_fixed_gate = have_fixed_gate

        self.reducer_is_tramec = \
            (self.drive != Drive.electric) and self.screws_number > 1

        if wedges_pairs_number is None:
            self.wedges_pairs_number = _wedges_pairs_number(
                self.hydr_head, self.frame_width, self.gate_height)
        else:
            self.wedges_pairs_number = wedges_pairs_number

        if is_left_hand_closing is None:
            self.is_left_hand_closing = self.motor_control is not None
        else:
            self.is_left_hand_closing = is_left_hand_closing

        if self.install in (Install.flange, Install.twoflange):
            self.bigpipe_length = 0.3
        else:
            self.bigpipe_length = 0

        self.have_reducer = self.screws_number > 1 or \
            self.drive == Drive.reducer

        self.optimal_frame_height = _optimal_frame_height(self.gate_height)

        if frame_height is None:
            self.frame_height = self.optimal_frame_height
        else:
            self.frame_height = frame_height

        if beth_frame_top_and_gate_top is None:
            self.beth_frame_top_and_gate_top = \
                self.frame_height - self.gate_height
        else:
            self.beth_frame_top_and_gate_top = beth_frame_top_and_gate_top

        if self.frame_height < _minimal_frame_height_for_nodes(
                self.gate_height):
            self.have_nodes_in_frame = False
        elif have_nodes_in_frame is None:
            self.have_nodes_in_frame = True
        else:
            self.have_nodes_in_frame = have_nodes_in_frame

        self.hydr_force = _hydr_force(
            self.frame_width, self.gate_height, self.hydr_head,
            self.liquid_density, self.tilt_angle)

        self.sealing_compress_force = _sealing_compress_force(
            self.kind, self.frame_width, self.gate_height)

        self.gate_force = self.hydr_force + self.sealing_compress_force

        self.screw_length = _screw_length(
            self.have_nodes_in_frame, self.gate_height, self.frame_height)

        if self.kind == SlgKind.flow:
            self.wedges_angle = 0.0
        else:
            self.wedges_angle = radians(15)

        self.min_axial_force_in_one_screw = _min_axial_force(
            self.gate_force, self.wedges_angle, self.screws_number)

        # print(self.min_axial_force_in_one_screw)  ######################

        self.min_screw_inertia_moment = min_inertia_moment(
            self.min_axial_force_in_one_screw, RECOMMEND_FOS,
            self.screw_length, SCREW_ELAST, SCREW_MJU)

        self.min_screw_minor_diam = diam_by_inertia_moment(
            self.min_screw_inertia_moment)

        if way is None:
            self.way = _way(self.gate_height, self.frame_height,
                            self.optimal_frame_height)
        else:
            self.way = way

        if screw_diam is None:
            self.screw = _screw(self.min_screw_minor_diam)
        else:
            self.screw = TrapezoidalScrew(screw_diam)

        min_torque_in_one_screw = _min_close_moment(
            self.min_axial_force_in_one_screw, self.screw) + DELTA_OPEN

        if self.have_reducer:
            if reducer is None:
                self.reducer = _reducer(
                    min_torque_in_one_screw, self.reducer_is_tramec,
                    self.is_screw_pullout)
            else:
                self.reducer = reducer
            self.sleeve_gk = _sleeve_gk(self.is_screw_pullout)
            ratio = self.reducer.ratio
        else:
            ratio = 1

        min_torque_in_drive = \
            min_torque_in_one_screw * self.screws_number / ratio

        self.revs = self.way / self.screw.pitch * ratio

        if self.drive == Drive.electric:
            if auma is None:
                for self.mode in MotorMode:
                    min_speed = _min_speed(self.revs, MIN_OPEN_TIME[self.mode])
                    try:
                        self.auma = _auma(min_torque_in_drive, min_speed,
                                          self.mode, self.kind,
                                          self.screws_number)
                    except AumaError:
                        continue
                    else:
                        break
                else:
                    raise Error('Failed with calculation auma')
            else:
                self.auma = auma
                self.mode = MotorMode.normal  # FIXME
            self.open_time = self.revs / self.auma.speed
            self.sleeve_sa = _sleeve_sa(self.screws_number,
                                        self.is_screw_pullout)
            self.torque_in_drive = max(
                self.auma.min_torque + DELTA_OPEN * self.screws_number,
                min_torque_in_drive)
            self.auma_temp_range: Optional[Tuple[float, float]] = \
                auma_temperature_range(self.auma, self.motor_control)
        else:
            self.torque_in_drive = min_torque_in_drive
            self.auma_temp_range = None

        self.close_torque_in_drive = \
            self.torque_in_drive - DELTA_OPEN * self.screws_number

        self.torque_in_one_screw = \
            self.torque_in_drive / self.screws_number * ratio

        self.axial_force_in_one_screw = \
            _real_axial_force(self.torque_in_one_screw, self.screw)

        # print(self.axial_force_in_one_screw)  ###########################

        if screw_diam is None:
            new_screw = _check_screw(self.axial_force_in_one_screw,
                                     self.screw_length)
            if new_screw.minor_diam > self.screw.minor_diam:
                self.screw = new_screw

        if self.kind == SlgKind.flow:
            force = self.gate_force  # всегда уплотненный щит
        else:
            force = self.hydr_force  # свободный щит

        self.free_torque_in_one_screw = _min_close_moment(_min_axial_force(
            force, 0.0, self.screws_number), self.screw)

        self.nut_axe = _nut_axe(self.axial_force_in_one_screw)

        self.screw_fos = fos_calc(self.screw.minor_diam, self.screw_length,
                                  SCREW_ELAST, self.axial_force_in_one_screw)

        # _mass_calculation(self)
        self.thickness = {i: 0.0 for i in THICKNESS}
        if self.kind != SlgKind.flow:
            common_axial_force = \
                self.screws_number * self.axial_force_in_one_screw
            self.min_bolts_by_all_pairs = \
                _bolt_by_minor_diam(diam_circle_by_force_shear(
                    common_axial_force / self.wedges_pairs_number /
                    ONE_WEDGE_BOLTS_NUMBER, LIMIT_SHEAR_STRESS), 0.008, True)

            # only by TWO wedge-pairs
            self.wedge = _wedge_by_bolt(
                _bolt_by_minor_diam(diam_circle_by_force_shear(
                    common_axial_force / 2 / ONE_WEDGE_BOLTS_NUMBER,
                    LIMIT_SHEAR_STRESS), 0.008, True))

        self.gate_s = 0.0
        self.gate_s_edge = 0.0
        self.frame_s = 0.0
        self.cover_s = 0.0

        self.gate_wall_mass = 0.0
        self.gate_edges_mass = 0.0
        self.gate_cover_mass = 0.0
        self.shelf_cover_gate = 0.0
        self.depth_cover_gate = 0.0
        self.gate_depth = 0.0
        self.gate_shelf = 0.0
        self.frame_depth = 0.0
        self.frame_shelf = 0.0
        self.mass = 0.0
        self.gate_mass = 0.0
        self.frame_mass = 0.0
        self.screw_mass = 0.0
        self.rack_mass = 0.0
        self.gate_width = 0.0
        self.edge_h = 0.0

        self.gate_horiz_edges_number = 0
        self.gate_vert_edges_number = 0
