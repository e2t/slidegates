from typing import NamedTuple
from screw import METRICS, MetricScrew


class Wedge(NamedTuple):
    bolt: MetricScrew
    depth: float
    width: float
    dist: float
    material: str


WEDGES = (Wedge(METRICS[9], 34e-3, 25e-3, 46e-3, 'polyamide'),   # M8
          Wedge(METRICS[10], 40e-3, 30e-3, 52e-3, 'polyamide'),  # M10
          Wedge(METRICS[11], 46e-3, 30e-3, 58e-3, 'bronze'),    # M12
          Wedge(METRICS[13], 56e-3, 40e-3, 68e-3, 'bronze'),    # M16
          Wedge(METRICS[15], 66e-3, 50e-3, 78e-3, 'bronze'))    # M20
