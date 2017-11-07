from math import pi
from typing import Tuple, NamedTuple
from math_func import area_ring_of_diam, ceilto, roundu, area_circle_of_diam
from slg import SlgKind, Install, RADIUS, THICKNESS, RACK_THICKNESS
from slidegate import Slidegate
from screw import Screw


class Nut(NamedTuple):
    diam: float
    size: float
    mass: float


NUTS = (Nut(26e-3, 60e-3, 2.3),
        Nut(30e-3, 60e-3, 2.2),
        Nut(42e-3, 75e-3, 3.1),
        Nut(55e-3, 90e-3, 4.1),
        Nut(65e-3, 100e-3, 5.2),
        Nut(75e-3, 115e-3, 8.0),
        Nut(80e-3, 125e-3, 10.3))

STEEL_DENSITY = 8000
SHELF = 0.05  # 50 mm - shelf of the top balk


def _thick_gate(wid: float, gate: float, bolt_wedge: Screw,
                head: float) -> float:
    if head < 3.0:
        limit3 = 1.0
    else:
        limit3 = 0.8
    if wid <= limit3 and gate <= limit3 and bolt_wedge.major_diam < 12e-3:
        result = 3e-3
    elif wid <= 1.6 and gate <= 1.6 and bolt_wedge.major_diam < 16e-3:
        result = 4e-3
    elif wid <= 2.5 and gate <= 2.5 and bolt_wedge.major_diam < 20e-3:
        result = 5e-3
    else:
        result = 6e-3
    return result


def _thick_frame(wid: float, frame: float, thick_gate: float,
                 gate: float) -> float:
    if wid <= 1.25 and gate <= 1.25 and frame <= 3.0:
        result = 4e-3
    elif wid <= 2.5 and gate <= 2.5 and frame <= 6.0:
        result = 5e-3
    else:
        result = 6e-3
    if result < thick_gate:
        result = thick_gate
    return result


def _thick_edge(s_gate: float, hydr_head: float) -> float:
    if hydr_head >= 8.0 and s_gate < THICKNESS[-1]:
        result = THICKNESS[THICKNESS.index(s_gate) + 1]
    else:
        result = s_gate
    return result


def _thick_cover_gate(thick_gate: float) -> float:
    cover_s = thick_gate / 1.5
    try:
        result = next(filter(lambda i: cover_s <= i, THICKNESS))
    except StopIteration:
        result = THICKNESS[-1]
    return result


def _size_nut(screw_major: float) -> float:
    try:
        nut = next(filter(lambda i: screw_major <= i.diam, NUTS))
    except StopIteration:
        nut = NUTS[-1]
    return nut.size


def _gate_width(frame_width: float, s_frame: float) -> float:
    gap = 0.01  # 2 mm gap + 8 mm limiter
    return frame_width - 2 * (s_frame + gap)


def _horiz_edge_width(gate_width: float, s_gate: float) -> float:
    return gate_width - 2 * (s_gate + 0.001)  # 1 mm gap


def _horiz_edge_square(edge_width: float, edge_height: float,
                       gate_shelf: float, gate_depth: float,
                       cover_shelf: float, cover_depth: float,
                       s_gate: float) -> float:
    hem_v = gate_depth - 2 * s_gate - 0.001  # 1 mm gap
    hem_h = gate_shelf - s_gate
    return (edge_width - 2 * hem_h - edge_height + hem_v) * \
        (edge_height - hem_v) + hem_v * edge_width - \
        cover_shelf * cover_depth


def _edge_height(slg: Slidegate) -> float:
    k_2 = 0.002  # mm, on every meter of hydr. head above gate
    return ceilto(slg.shelf_cover_gate + 0.015 +  # 15 mm above cover
                  k_2 * (slg.hydr_head - slg.gate_height) + slg.gate_s,
                  0.005) - slg.gate_s


def _horiz_edges_number(kind: SlgKind, gate_height: float) -> int:
    if kind == SlgKind.surf:
        result = 1 + roundu(gate_height / 0.32)
    elif kind == SlgKind.deep:
        result = 1 + roundu(gate_height / 0.25)
    else:
        result = 0
    return result


def _vert_edge_square(gate_height: float, edge_h: float) -> float:
    return gate_height * edge_h


def _top_channel_number(is_screw_pullout: bool) -> int:
    if is_screw_pullout:
        result = 1
    else:
        result = 2
    return result


def _bigpipe_diam(bigpipe_length: float, frame_width: float) -> float:
    # bigpipe = pipe - 40 mm, frame = pipe + 200 mm
    if bigpipe_length:
        result = frame_width - 0.24
    else:
        result = 0
    return result


def _number_segment(is_frame_closed: bool) -> int:
    if is_frame_closed:
        result = 2
    else:
        result = 1
    return result


# old version: EDGE_HEIGHT = (slg.frame.height - 2 * (diam + 0.1))
def _close_frame_edge_height(frame_height: float,
                             bigpipe_diam: float) -> float:
    # 100 mm from bellow to bigpipe
    return frame_height - bigpipe_diam - 0.1


def _frame_horiz_edge_number(edge_height: float, is_frame_closed: bool) -> int:
    if is_frame_closed:
        result = roundu(edge_height / 0.3)
    else:
        result = 0
    return result


def _frame_vert_edge_number(slg: Slidegate) -> int:
    # 1 edge on every 0.5 meter
    if slg.is_frame_closed:
        result = roundu((slg.frame_width - 0.5) / 0.5)
    else:
        result = 0
    return result


def _flange_number(slg: Slidegate) -> int:
    if slg.install == Install.twoflange:
        result = 2
    elif slg.install == Install.flange:
        result = 1
    else:
        result = 0
    return result


def _vert_edges_number(slg: Slidegate) -> int:
    if slg.kind in (SlgKind.surf, SlgKind.deep):
        if not slg.is_screw_pullout and slg.screws_number == 1:
            k = 2
        else:
            k = 1
        result = k * roundu(slg.gate_width / (2.5 if slg.kind == SlgKind.surf
                                              else 1.0))
    else:
        result = 0
    return result


def _profiles(slg: Slidegate) -> None:
    slg.gate_s = _thick_gate(
        slg.frame_width, slg.gate_height, slg.wedge.bolt, slg.hydr_head)
    slg.gate_s_edge = _thick_edge(slg.gate_s, slg.hydr_head)
    slg.frame_s = _thick_frame(slg.frame_width, slg.frame_height, slg.gate_s,
                               slg.gate_height)
    slg.cover_s = _thick_cover_gate(slg.gate_s)

    dist_compress = 13e-3
    k_1 = 0.0035  # mm, on every meter hydr. head above gate
    # Minimal difference between size of gate's shelf and size of gate's depth
    min_diff = 9e-3
    # Distance between radius of gate and wedge = 2 + 6
    dist_from_radius_to_wedge = 8e-3
    # Side distance between gate and frame including limiter = 2 + 8
    dist_limiter = 10e-3

    shelf_gate_2 = ceilto((slg.gate_s + RADIUS[slg.gate_s] +
                           (dist_from_radius_to_wedge + slg.wedge.width) +
                           # gap from side is 1/5 of wedge width
                           slg.wedge.width / 5), 2e-3)
    # only by two wedges pairs
    slg.gate_depth = ceilto(shelf_gate_2 + min_diff +
                            k_1 * (slg.hydr_head - slg.gate_height), 1e-3)
    slg.gate_shelf = ceilto((dist_from_radius_to_wedge + slg.wedge.width) *
                            (slg.wedges_pairs_number - 2) + shelf_gate_2, 2e-3)
    slg.frame_depth = ceilto((slg.gate_depth + dist_compress +
                              slg.wedge.dist + slg.frame_s * 2), 5e-3)
    slg.gate_depth = slg.frame_depth - slg.frame_s * 2 - slg.wedge.dist - \
        dist_compress
    slg.frame_shelf = ceilto(slg.frame_s + dist_limiter + slg.gate_shelf, 5e-3)

    # Distance between centre of frame and ax of nut = 10 - 9
    diff_centres = 1e-3
    # Inside distance between nut and cover of gate
    diff_side = 1e-3

    size_nut = _size_nut(slg.screw.major_diam)
    o_a = slg.frame_depth / 2 - slg.frame_s - dist_compress - slg.gate_s - \
        (0.009 if slg.install == Install.twoflange else 0)
    o_b = diff_centres + size_nut / 2 + diff_side + slg.cover_s
    slg.shelf_cover_gate = ceilto(o_a + o_b, 1e-3)
    slg.depth_cover_gate = size_nut + 2 * (diff_side + slg.cover_s)

    slg.gate_width = _gate_width(slg.frame_width, slg.frame_s)


# only 90 degrees
def _square_radius_sheet(thick: float) -> float:
    return area_ring_of_diam((RADIUS[thick] + thick) * 2, RADIUS[thick] * 2,
                             pi / 2)


def _square_sheet_metal(thick: float, sides: Tuple[float, ...]) -> float:
    flat_length = sides[0] + sum(
        [i - (thick + RADIUS[thick]) * 2 for i in sides[1:]])
    return (len(sides) - 1) * _square_radius_sheet(thick) + flat_length * thick


def _mass_frame(slg: Slidegate) -> float:
    result = _mass_channel(slg) * 2 + _mass_bottom(slg) + \
        _mass_top_channel(slg) * _top_channel_number(slg.is_screw_pullout) + \
        _mass_bar4deep(slg) + _mass_middle_support_of_screw(slg) + \
        _mass_crossbar(slg) + _mass_small_bottom(slg)
    if slg.bigpipe_length or slg.is_frame_closed:
        bigpipe_diam = _bigpipe_diam(slg.bigpipe_length, slg.frame_width)
        edge_height = _close_frame_edge_height(slg.frame_height, bigpipe_diam)
        result += _mass_bigpipe(slg, bigpipe_diam) + \
            (_mass_bottom_segment(slg, bigpipe_diam) +
             _mass_top_segment(slg, bigpipe_diam)) * \
            _number_segment(slg.is_frame_closed) + \
            _mass_cap(slg) + _mass_frame_horiz_edge(slg) * \
            _frame_horiz_edge_number(edge_height, slg.is_frame_closed) + \
            _mass_frame_vert_edge(slg, edge_height) * \
            _frame_vert_edge_number(slg) + \
            _mass_flange(slg, bigpipe_diam) * _flange_number(slg)
    if slg.install == Install.channel:
        result += _mass_bracket(slg)
    return result


# Brackets for the anchors
def _mass_bracket(slg: Slidegate) -> float:
    # 0.32 kg - mass of bracket for the surf. slidegates
    return 0.32 * (4 + 4 * (3 if slg.gate_height >= 1.0 else 2))


# The crossbar for the top sealing in the deep slidegates.
def _mass_bar4deep(slg: Slidegate) -> float:
    gap = 0.01  # indent 10 mm at both sides
    height = 0.135  # 135 mm height of channel
    # 50 mm ledge, 8 mm thickness of flange
    shelf = 0.05 - 0.008 + slg.frame_s
    return (_square_sheet_metal(slg.frame_s, (shelf, height, shelf + 0.004)) *
            (slg.frame_width - 2 * gap) - 2 * (height - 2 * slg.frame_s) *
            (slg.frame_shelf - gap) * slg.frame_s) * STEEL_DENSITY if \
        slg.kind == SlgKind.deep else 0.0


def _mass_middle_support_of_screw(slg: Slidegate) -> float:
    if slg.have_nodes_in_frame:
        result = _mass_horiz_channel_with_plast(slg)
    else:
        result = 0
    return result


# The crossbar in the very high frames.
def _mass_crossbar(slg: Slidegate) -> float:
    if slg.have_nodes_in_frame:
        height = 2 * slg.gate_height
    elif slg.kind == SlgKind.deep:
        height = slg.gate_height
    else:
        height = 0
    return _mass_horiz_channel_wo_plastic(slg) * \
        int((slg.frame_height - height) / 3.0)


def _mass_flange(slg: Slidegate, diam: float) -> float:
    # round flanges s20, difference of the diameters 200 mm
    # square flanges s8, 100 mm from below, 140 mm from above
    return (area_ring_of_diam(diam + 0.2, diam, 2 * pi) * 0.02 if
            slg.install in (Install.flange, Install.twoflange)
            else (slg.frame_width * (0.1 + 0.14) +
                  (slg.gate_height - 0.1 - 0.14) * 2 * slg.frame_shelf) *
            0.008) * STEEL_DENSITY


def _mass_frame_vert_edge(slg: Slidegate, edge_height: float) -> float:
    # 50 mm of the top balk x 2
    return 0.05 * edge_height * slg.frame_s * STEEL_DENSITY


def _mass_frame_horiz_edge(slg: Slidegate) -> float:
    # 50 mm of the top balk x 2
    return ((slg.frame_width + 0.1) * (slg.frame_depth + 0.1) -
            slg.frame_width * slg.frame_depth) * slg.frame_s * STEEL_DENSITY


def _mass_cap(slg: Slidegate) -> float:
    # 50 mm of the top balk
    return ((slg.frame_width + 0.1) * (slg.frame_depth + 0.1) *
            slg.frame_s * STEEL_DENSITY) if slg.is_frame_closed else 0


def _mass_top_segment(slg: Slidegate, diam: float) -> float:
    return _mass_segment(slg, diam, (slg.frame_height - 0.1 - diam) if
                         slg.is_frame_closed else 0.1)


def _mass_bottom_segment(slg: Slidegate, diam: float) -> float:
    # 100 mm from below to bigpipe
    return _mass_segment(slg, diam, 0.1)


def _mass_segment(slg: Slidegate, diam: float, height: float) -> float:
    return ((height + diam / 2) * (slg.frame_width - 2 * slg.frame_shelf) -
            area_circle_of_diam(diam, pi)) * slg.frame_s * STEEL_DENSITY


def _mass_bigpipe(slg: Slidegate, diam: float) -> float:
    return area_ring_of_diam(diam, diam - 2 * slg.frame_s, 2 * pi)


def _mass_top_channel(slg: Slidegate) -> float:
    # at 20 mm narrower of the frame, at 20 mm below of the channel
    return _mass_horiz_channel_with_plast(slg) if slg.is_screw_pullout \
        else _mass_horiz_channel_wo_plastic(slg)


def _mass_horiz_channel_wo_plastic(slg: Slidegate) -> float:
    # at 20 mm narrower of the frame, at 20 mm below of the channel
    return _square_sheet_metal(slg.frame_s, (
        SHELF, slg.frame_depth - 0.02, SHELF)) * (slg.frame_width - 0.02) * \
        STEEL_DENSITY


def _mass_horiz_channel_with_plast(slg: Slidegate) -> float:
    # at 20 mm narrower of the frame, at 1 mm less of the channel (gap)
    return _square_sheet_metal(slg.frame_s, (
        SHELF, slg.frame_depth - 2 * slg.frame_s - 0.001, SHELF)) * \
        (slg.frame_width - 0.02) * STEEL_DENSITY


# The bottom support-corner
def _mass_small_bottom(slg: Slidegate) -> float:
    return _square_sheet_metal(slg.frame_s, (0.035, 0.05 - slg.frame_s)) * \
        slg.frame_width * STEEL_DENSITY


def _mass_bottom(slg: Slidegate) -> float:
    top_shelf = 0.0
    sealing_height = 0.1  # 100 mm height seal pressing

    # 35 mm top shelf by default, 46+s for the flange to wall,
    # don't exists with bigpipe
    if slg.bigpipe_length:
        top_shelf = 0.035 if slg.kind != Install.wall else 0.046 + slg.frame_s
    area_break = _square_sheet_metal(slg.frame_s, (sealing_height, top_shelf))
    # 50 mm bottom shelf, 5 mm indent at channel
    return STEEL_DENSITY * (
        _square_sheet_metal(slg.frame_s, (
            0.05, slg.frame_depth + 0.005, sealing_height + slg.frame_s,
            top_shelf)) *
        slg.frame_width - area_break * slg.frame_s)


def _mass_channel(slg: Slidegate) -> float:
    if slg.install == Install.wall:
        # 46 mm ledge of flange, 150 mm internal height of flange
        flange_shelf_area = (0.046 + slg.frame_s) * (slg.gate_height - 0.15)
    else:
        flange_shelf_area = 0
    return STEEL_DENSITY * (
        _square_sheet_metal(slg.frame_s, (slg.frame_shelf, slg.frame_depth,
                                          slg.frame_shelf)) *
        slg.frame_height + flange_shelf_area * slg.frame_s)


def _mass_gate(slg: Slidegate) -> float:
    slg.edge_h = _edge_height(slg)
    slg.gate_horiz_edges_number = _horiz_edges_number(slg.kind,
                                                      slg.gate_height)
    slg.gate_vert_edges_number = _vert_edges_number(slg)

    slg.gate_wall_mass = _mass_wall(
        slg.gate_height, slg.gate_shelf, slg.gate_depth, slg.gate_width,
        slg.gate_s)
    slg.gate_edges_mass = \
        slg.gate_horiz_edges_number * _mass_horiz_edge(
            slg.gate_width, slg.gate_s_edge, slg.gate_shelf, slg.gate_depth,
            slg.shelf_cover_gate, slg.depth_cover_gate, slg.edge_h) + \
        slg.gate_vert_edges_number * _mass_vert_edge(
            slg.gate_height, slg.edge_h, slg.gate_s_edge)
    slg.gate_cover_mass = slg.screws_number * _mass_cover(
        slg.shelf_cover_gate, slg.depth_cover_gate, slg.gate_height,
        slg.cover_s)
    return sum((slg.gate_wall_mass, slg.gate_edges_mass, slg.gate_cover_mass))


def _mass_vert_edge(gate_height: float, edge_h: float, thick: float) -> float:
    return _vert_edge_square(gate_height, edge_h) * thick * STEEL_DENSITY


def _mass_cover(cover_shelf: float, cover_depth: float, gate_height: float,
                s_cover: float) -> float:
    return gate_height * STEEL_DENSITY * _square_sheet_metal(
        s_cover, (cover_shelf, cover_depth, cover_shelf))


def _mass_horiz_edge(gate_width: float, thick: float, gate_shelf: float,
                     gate_depth: float, cover_shelf: float, cover_depth: float,
                     edge_h: float) -> float:
    horiz_edge_width = _horiz_edge_width(gate_width, thick)
    return thick * STEEL_DENSITY * _horiz_edge_square(
        horiz_edge_width, edge_h, gate_shelf, gate_depth, cover_shelf,
        cover_depth, thick)


def _mass_wall(height: float, shelf: float, depth: float, width: float,
               thick: float) -> float:
    return _square_sheet_metal(thick, (shelf, depth, width, depth, shelf)) * \
        height * STEEL_DENSITY


def _mass_screw(slg: Slidegate) -> float:
    # 310 mm in the bearing housing and the drive
    alen = 0.31
    # area of the solid rod
    area = area_circle_of_diam(slg.screw.major_diam, 2 * pi)
    # 100 mm height of the nut, 100 mm above the frame
    common_len = slg.frame_height - slg.gate_height + 0.1 + 0.1
    rod_len = slg.screw_length + alen if \
        slg.frame_height >= 2 * slg.gate_height + 0.5 else common_len
    # 4 mm thickness of the pipe
    return slg.screws_number * (
        (area * rod_len +  # weight of the rod
         (common_len - rod_len) * area_ring_of_diam(  # weight of the pipe
             slg.screw.major_diam,
             slg.screw.major_diam - 2 * 0.004, 2 * pi) +
         # minus 580 mm - length of the shaft
         area * (slg.frame_width - 0.58)) *
        STEEL_DENSITY +
        3.0 +  # plate
        4.0 *  # bearing housing
        (2 if not slg.is_screw_pullout and slg.have_rack else 1))


def _select_thickness(slg: Slidegate) -> None:
    slg.thickness[slg.gate_s] += slg.gate_wall_mass
    slg.thickness[slg.gate_s_edge] += slg.gate_edges_mass
    slg.thickness[slg.cover_s] += slg.gate_cover_mass
    slg.thickness[slg.frame_s] += slg.frame_mass
    slg.thickness[RACK_THICKNESS] += slg.rack_mass


def calculation(slg: Slidegate) -> None:
    _profiles(slg)
    slg.gate_mass = _mass_gate(slg)
    slg.frame_mass = _mass_frame(slg)
    slg.screw_mass = _mass_screw(slg)
    _select_thickness(slg)
