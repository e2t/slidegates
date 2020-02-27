from math import atan, pi
from typing import Tuple


class Screw:
    def __init__(self, major_diam: float, pitch_diam: float, minor_diam: float,
                 pitch: float) -> None:
        self._major_diam = major_diam
        self._pitch_diam = pitch_diam
        self._minor_diam = minor_diam
        self._pitch = pitch
        self._thread_angle = atan(self._pitch / pi / self._pitch_diam)

    @property
    def major_diam(self) -> float:
        return self._major_diam

    @property
    def pitch_diam(self) -> float:
        return self._pitch_diam

    @property
    def minor_diam(self) -> float:
        return self._minor_diam

    @property
    def pitch(self) -> float:
        return self._pitch

    @property
    def thread_angle(self) -> float:
        return self._thread_angle


class TrapezoidalScrew(Screw):
    def __init__(self, diam: float, pitch: float) -> None:
        super().__init__(diam, diam - pitch / 2, diam - pitch, pitch)

    def __str__(self) -> str:
        return 'Tr{0:g}x{1:g}'.format(self._major_diam * 1e3,
                                      self._pitch * 1e3)


SCREWS = (TrapezoidalScrew(0.030, 0.006),
          TrapezoidalScrew(0.040, 0.007),
          TrapezoidalScrew(0.050, 0.008),
          TrapezoidalScrew(0.060, 0.009),
          TrapezoidalScrew(0.070, 0.010),
          TrapezoidalScrew(0.080, 0.010),
          TrapezoidalScrew(0.090, 0.012))


PURCHASED_SCREWS = [x.major_diam for x in SCREWS[:3]]


class MetricScrew(Screw):
    def __init__(self, diameters: Tuple[float, float, float], pitch: float,
                 is_recommend: bool) -> None:
        super().__init__(diameters[0], diameters[1], diameters[2], pitch)
        self._is_recommend = is_recommend

    @property
    def is_recommend(self) -> bool:
        return self._is_recommend

    def __str__(self) -> str:
        return 'M{0:g}'.format(self._major_diam * 1e3)


METRICS = (MetricScrew((2e-3, 1.74e-3, 1.567e-3), 0.4e-3, True),
           MetricScrew((2.2e-3, 1.908e-3, 1.713e-3), 0.45e-3, False),
           MetricScrew((2.5e-3, 2.208e-3, 2.013e-3), 0.45e-3, True),
           MetricScrew((3e-3, 2.675e-3, 2.459e-3), 0.5e-3, True),
           MetricScrew((3.5e-3, 3.11e-3, 2.85e-3), 0.6e-3, False),
           MetricScrew((4e-3, 3.546e-3, 3.242e-3), 0.7e-3, True),
           MetricScrew((4.5e-3, 4.013e-3, 3.688e-3), 0.75e-3, False),
           MetricScrew((5e-3, 4.48e-3, 4.134e-3), 0.8e-3, True),
           MetricScrew((6e-3, 5.35e-3, 4.918e-3), 1e-3, True),
           MetricScrew((8e-3, 7.188e-3, 6.647e-3), 1.25e-3, True),
           MetricScrew((10e-3, 9.026e-3, 8.376e-3), 1.5e-3, True),
           MetricScrew((12e-3, 10.863e-3, 10.106e-3), 1.75e-3, True),
           MetricScrew((14e-3, 12.701e-3, 11.835e-3), 2e-3, False),
           MetricScrew((16e-3, 14.701e-3, 13.835e-3), 2e-3, True),
           MetricScrew((18e-3, 16.376e-3, 15.294e-3), 2.5e-3, False),
           MetricScrew((20e-3, 18.376e-3, 17.294e-3), 2.5e-3, True),
           MetricScrew((22e-3, 20.376e-3, 19.294e-3), 2.5e-3, False),
           MetricScrew((24e-3, 22.051e-3, 20.752e-3), 3e-3, True),
           MetricScrew((27e-3, 25.051e-3, 23.752e-3), 3e-3, False),
           MetricScrew((30e-3, 27.727e-3, 26.211e-3), 3.5e-3, True),
           MetricScrew((33e-3, 30.727e-3, 29.211e-3), 3.5e-3, False),
           MetricScrew((36e-3, 33.402e-3, 31.67e-3), 4e-3, True),
           MetricScrew((39e-3, 36.402e-3, 34.67e-3), 4e-3, False),
           MetricScrew((42e-3, 39.077e-3, 37.129e-3), 4.5e-3, True),
           MetricScrew((45e-3, 42.077e-3, 40.129e-3), 4.5e-3, False),
           MetricScrew((48e-3, 44.752e-3, 42.587e-3), 5e-3, True),
           MetricScrew((52e-3, 48.752e-3, 46.587e-3), 5e-3, False),
           MetricScrew((56e-3, 52.428e-3, 50.046e-3), 5.5e-3, True),
           MetricScrew((60e-3, 56.428e-3, 54.046e-3), 5.5e-3, False),
           MetricScrew((64e-3, 60.103e-3, 57.505e-3), 6e-3, True),
           MetricScrew((68e-3, 64.103e-3, 61.505e-3), 6e-3, False))
