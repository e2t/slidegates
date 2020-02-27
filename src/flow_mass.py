"""Вычисление массы переливных затворов."""
from math import floor
from slidegate import Slidegate
from slg import RACK_THICKNESS


def _profiles(slg: Slidegate) -> None:
    slg.frame_s = 5e-3
    slg.gate_s = 5e-3


def _mass_fixed_gate(slg: Slidegate) -> float:
    steel_density = 7.85e-6  # kg/mm3
    return (slg.frame_height * 1e3 - slg.beth_frame_top_and_gate_top * 1e3
            - slg.gate_height * 1e3 - 40) * (slg.frame_width * 1e3 - 170) \
        * 5 * steel_density + (0.008 * slg.frame_width * 1e3 - 0.001)


def _mass_frame(slg: Slidegate) -> float:
    result = (
        (0.012 * slg.frame_width * 1e3 - 2.103)         # нижняя балка
        + (0.012 * slg.frame_height * 1e3 - 0.016) * 2  # обе стойки
        + (0.007 * slg.frame_width * 1e3 - 1.242) * 2   # верх. и пром. балка
        + (0.005 * slg.frame_width * 1e3 - 0.806)       # top corner
        + 4 + (0.004 * (slg.frame_height * 1e3
                        - slg.beth_frame_top_and_gate_top * 1e3)
               - 0.26) * 2)
    if slg.have_fixed_gate:
        result += _mass_fixed_gate(slg)
    return result


def _mass_gate(slg: Slidegate) -> float:
    return (
        (4.058e-5 * slg.frame_width * 1e3 * slg.gate_height * 1e3 +
         - 5.059e-3 * slg.frame_width * 1e3 - 0.00419 * slg.gate_height * 1e3)
        + (0.003 * slg.gate_height * 1e3 - 0.033)
        * round(slg.frame_width * 1e3 / 300)
        + (0.003 * slg.frame_width * 1e3 - 0.61)
        * floor(slg.gate_height * 1e3 / 300))


def _mass_screw(slg: Slidegate) -> float:
    return 0.011 * slg.beth_frame_top_and_gate_top * 1e3 + 1.756


def _select_thickness(slg: Slidegate) -> None:
    slg.thickness[slg.gate_s] += slg.gate_mass
    slg.thickness[slg.frame_s] += slg.frame_mass
    slg.thickness[RACK_THICKNESS] += slg.rack_mass


def calculation(slg: Slidegate) -> None:
    _profiles(slg)
    slg.gate_mass = _mass_gate(slg)
    slg.frame_mass = _mass_frame(slg)
    slg.screw_mass = _mass_screw(slg)
    _select_thickness(slg)
