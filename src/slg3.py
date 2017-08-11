import wedge_mass
import flow_mass
from slidegate import Slidegate, SlgKind


def _mass_rack(have_rack: bool) -> float:
    if have_rack:
        result = 25
    else:
        result = 0
    return result


def mass_calculation(slg: Slidegate) -> None:
    slg.rack_mass = _mass_rack(slg.have_rack)
    if slg.kind != SlgKind.flow:
        wedge_mass.calculation(slg)
    else:
        flow_mass.calculation(slg)
    slg.mass = slg.gate_mass + slg.frame_mass + slg.screw_mass + \
        slg.rack_mass * slg.screws_number