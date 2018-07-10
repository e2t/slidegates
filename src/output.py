import sys
from slg import SlgKind, Drive
from slidegate import Slidegate
from math_func import ceilto
sys.path.append(f'{sys.path[0]}/..')
from dry.core import get_translate, get_dir_current_file


def rpm(rps: float) -> float:
    return rps * 60


def m_to_mm(meters: float) -> float:
    return meters * 1000


def output_result(slg: Slidegate, lang: str) -> str:
    _ = get_translate(get_dir_current_file(__file__), lang, 'messages')
    lines = []
    if slg.screws_number > 1:
        screws_number = ' (x{0})'.format(slg.screws_number)
    else:
        screws_number = ''

    def add(text: str) -> None:
        lines.append(text)

    def add_empty_line() -> None:
        lines.append('')

    def add_actuator() -> None:
        if slg.motor_control is not None:
            aumatic = ' / {0}'.format(
                slg.auma.control_names[slg.motor_control])
        else:
            aumatic = ''

        add(_('Actuator AUMA {auma_name}{aumatic}').format(
            auma_name=slg.auma.name, aumatic=aumatic))
        add(_(" * the general parameters:"))
        add(_('output speed {speed:g} rpm').format(
            speed=rpm(slg.auma.speed)))
        add(_('electric power {power} kW').format(
            power=slg.auma.powers[slg.mode] / 1e3))
        add(_('torque {min_torque}-{max_torque} Nm').format(
            min_torque=slg.auma.min_torque,
            max_torque=slg.auma.max_torques[slg.mode]))
        add(_('flange type {flange}').format(flange=slg.auma.flange))
        add(_('valve attachment {sleeve}').format(sleeve=slg.sleeve_sa))
        add(_('type of duty {mode}').format(
            mode=slg.auma.mode_names[slg.mode]))
        if slg.is_left_hand_closing:
            add(_('left-hand closing (counter-clockwise)'))
        else:
            add(_('right-hand closing (clockwise)'))
            add(_('the reverse marking open/close on the handwheel'))
        add(_('torque {open_torque} Nm for opening, '
              '{close_torque} Nm for closing').format(
                  open_torque=round(slg.torque_in_drive),
                  close_torque=round(slg.close_torque_in_drive)))
        add(_('full opening through {time_min} min ({time_sec} sec) and '
              '{revs} rev').format(time_min=round(slg.open_time / 60, 1),
                                   time_sec=round(slg.open_time),
                                   revs=round(slg.revs)))
        add(_('temperature range {min_temp} °C to {max_temp} °C').format(
            min_temp=slg.auma_temp_range[0],
            max_temp=slg.auma_temp_range[1]))
        add(_('weight {mass} kg').format(mass=slg.auma.mass))

        add(_(' * the parameters of the motor:'))
        add(_('voltage 380 V / 50 Hz / 3ph'))
        add(_('general industrial design'))
        add(_('enclosure protection — IP 68'))
        add(_('corrosion protection — KS'))
        add(_('limit switches — single'))
        add(_('intermediate position switches — no'))
        add(_('torque switches — single'))
        add(_('blinker transmitter — yes'))
        add(_('mechanical position indication — no'))
        add(_('stem protection tube — no'))
        add(_('electronic position transmitter — no'))

        add(_(' * the parameters of the cable:'))
        add(_('cable glands — yes'))
        add(_('cable type — unarmoured'))
        add(_('outside cable diameter — standard'))

        add(_(' * the parameters of the control:'))
        add(_('actuator controls — {name_or_no}').format(
            name_or_no=_('no') if slg.motor_control is None else
            slg.auma.control_names[slg.motor_control]))
        add_empty_line()

    def add_reducer_gk(has_flange_for_actuator: bool) -> None:
        add(_('Right angle gearbox {name}').format(
            name=slg.reducer.name, number=screws_number))
        add(_(" * the general parameters:"))
        add(_('ratio {ratio}:1').format(ratio=slg.reducer.ratio))
        add(_('max torque {torque} Nm').format(
            torque=slg.reducer.max_torque))
        add(_('flange type {flange}').format(flange=slg.reducer.flange))
        add(_('valve attachment {sleeve}').format(sleeve=slg.sleeve_gk))
        if has_flange_for_actuator:
            add(_('mounting flange {flange} for the actuator').format(
                flange=slg.auma.flange))
        add(_('weight {mass} kg').format(mass=slg.reducer.mass))
        add_empty_line()

    def add_reducer_tramec() -> None:
        add(_('Right angle gearbox {name} {param}').format(
            name=slg.reducer.name, param='C1 F B7 FLS'))
        add(_('Right angle gearbox {name} {param}').format(
            name=slg.reducer.name, param='C1 E B7 FLS SEA'))
        add(_(" * the general parameters:"))
        add(_('ratio {ratio}:1').format(ratio=slg.reducer.ratio))
        add(_('max torque {torque} Nm').format(
            torque=slg.reducer.max_torque))
        add(_('weight {mass} kg').format(mass=slg.reducer.mass))
        add_empty_line()

    if slg.kind == SlgKind.deep:
        letter_type = _('D')
    elif slg.kind == SlgKind.surf:
        letter_type = _('S')
    elif slg.have_fixed_gate:
        letter_type = _('SOR')
    else:
        letter_type = _('DOR')

    if slg.drive == Drive.electric:
        letter_drive = _('E')
    else:
        letter_drive = _('M')

    add(_('SG{l_type}{l_drive} {frame_w}x{frame_h}({gate_h})').format(
        l_type=letter_type,
        l_drive=letter_drive,
        frame_w=round(slg.frame_width, 3),
        frame_h=round(slg.frame_height, 3),
        gate_h=round(slg.gate_height, 3)))

    add(_('Pressure head {head} m H2O').format(head=slg.hydr_head))

    add(_('Weight of stainless steel {mass} kg').format(
        mass=round(slg.mass, 1)))

    add_empty_line()

    for i in slg.thickness:
        if slg.thickness[i]:
            add(_('Sheet {thickness:g} mm AISI 304 — {mass:.1f} kg').format(
                thickness=i * 1e3, mass=slg.thickness[i]))

    def diam_rod(major_diam: float) -> float:
        return ceilto(major_diam + 0.003, 0.005)

    def add_screw(screw_type: str, number: str) -> None:
        add(_('{screw} {thread}{circle} AISI 304 — '
              '{length:.1f} m{number}').format(
                  screw=_(screw_type), thread=slg.screw, number=number,
                  circle=_(' (calibrated rod {diam:g})').format(
                      diam=diam_rod(slg.screw.major_diam) * 1e3)
                  if slg.screw.major_diam < 0.05 else '',
                  length=slg.way + 0.3))

    if slg.screws_number > 1 and not slg.reducer_is_tramec:
        add_screw('Right-hand screw', '')
        add_screw('Left-hand screw', '')
    else:
        add_screw('Right-hand screw', screws_number)

    add_empty_line()

    if slg.reducer_is_tramec:
        add_reducer_tramec()
    else:
        if slg.drive == Drive.electric:
            add_actuator()
        if slg.have_reducer:
            add_reducer_gk(False)
            if slg.drive == Drive.electric:
                add_reducer_gk(True)

    add(_('Screw - {screw}{number}, factor of safity {fos}').format(
        screw=slg.screw, number=screws_number, fos=round(slg.screw_fos, 1)))

    if slg.screws_number == 1:
        axial_force = _('Axial force in screw {force} N')
        torque_screw = _('Torque in screw {torque} Nm')
        free_torque_screw = _('Free torque in screw {torque} Nm')
    else:
        axial_force = _('Axial force in every screw {force} N')
        torque_screw = _('Torque in every screw {torque} Nm')
        free_torque_screw = _('Free torque in every screw {torque} Nm')

    add(_(axial_force).format(force=round(slg.axial_force_in_one_screw)))

    add(torque_screw.format(torque=round(slg.torque_in_one_screw)))

    add(_(free_torque_screw.format(
        torque=round(slg.free_torque_in_one_screw))))

    add_empty_line()

    if slg.have_nodes_in_frame:
        add(_('Frame with crossbar for screw'))
    else:
        add(_('Frame without crossbar for screw'))

    if slg.kind != SlgKind.flow:

        if slg.min_bolts_by_all_pairs.minor_diam > slg.wedge.bolt.minor_diam:
            the_all = _(' ({bolt} for the {number} pairs)').format(
                bolt=slg.min_bolts_by_all_pairs,
                number=slg.wedges_pairs_number)
        else:
            the_all = ''

        add(_('Wedges {wedge} ({material}) - {pairs} pairs{all}').format(
            wedge=slg.wedge.bolt,
            material=_(slg.wedge.material),
            pairs=slg.wedges_pairs_number,
            all=the_all))

        add(_('The frame {depth} x {shelf} mm, s = {thick} mm').format(
            depth=round(slg.frame_depth * 1e3),
            shelf=round(slg.frame_shelf * 1e3),
            thick=round(slg.frame_s * 1e3, 1)))

        add(_('The gate {width} x {depth} x {shelf} mm, '
              's = {thick} mm').format(depth=round(slg.gate_depth * 1e3),
                                       shelf=round(slg.gate_shelf * 1e3),
                                       width=round(slg.gate_width * 1e3),
                                       thick=round(slg.gate_s * 1e3, 1)))

        if slg.gate_vert_edges_number:
            vert = _(', vertical {vert}').format(
                vert=slg.gate_vert_edges_number)
        else:
            vert = ''

        add(_('Edges of the gate {height}, s = {thick} mm: '
              'horizontal {horiz}{vert}').format(
                  horiz=slg.gate_horiz_edges_number,
                  vert=vert,
                  thick=round(slg.gate_s_edge * 1e3, 1),
                  height=round(slg.edge_h * 1e3)))

        add(_('Profile of the cover {depth} x {shelf} mm, '
              's = {thick} mm').format(
                  depth=round(slg.depth_cover_gate * 1e3),
                  shelf=round(slg.shelf_cover_gate * 1e3),
                  thick=round(slg.cover_s * 1e3, 1)))

    add(_('Minimum diameter of the nut axis {diam} mm').format(
        diam=round(m_to_mm(slg.nut_axe), 1)))

    add_empty_line()

    add(_('Force on gate - {force} N').format(force=round(slg.gate_force)))

    return '\n'.join(lines)
