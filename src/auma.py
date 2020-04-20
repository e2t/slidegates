"""Data of the AUMA production."""
from enum import IntEnum, unique
from typing import NamedTuple, Tuple, Optional


@unique
class MotorMode(IntEnum):
    """
    Тип режимов работы привода.

    Обычный:     S2-15, S4-25%
    Увеличенный: S2-30, S4-50%
    """

    normal, large = range(2)


# TODO: Separate name, mode_names, control_names into superclass.
class Auma(NamedTuple):
    """Многооборотный мотор-редуктор SA и SAR."""

    name: str
    speed: float                      # rev/sec
    min_torque: float                 # N*m
    max_torques: Tuple[float, float]  # N*m
    powers: Tuple[float, float]       # W
    flange: str
    mass: float                       # kg
    selflock: bool
    mode_names: Tuple[str, str]
    control_names: Tuple[str, str]


class RightAngleGearbox(NamedTuple):
    """Угловой редуктор общего вида."""

    name: str
    max_torque: float  # N*m
    ratio: float       # float >= 1 (example, 4:1)
    flange: Optional[str]
    mass: float


MIN_OPEN_TIME = (6 * 60, 13.5 * 60)  # sec
SA_MODE_NAMES = ('S2-15 min', 'S2-30 min')
SAR_MODE_NAMES = ('S4-25%', 'S4-50%')

NAME_SA_07_2 = 'SA 07.2'
NAME_SA_07_6 = 'SA 07.6'
NAME_SA_10_2 = 'SA 10.2'
NAME_SA_14_2 = 'SA 14.2'
NAME_SA_14_6 = 'SA 14.6'
NAME_SA_16_2 = 'SA 16.2'
NAME_SA_25_1 = 'SA 25.1'
NAME_SA_30_1 = 'SA 30.1'
NAME_SA_35_1 = 'SA 35.1'
NAME_SA_40_1 = 'SA 40.1'
NAME_SA_48_1 = 'SA 48.1'

NAME_SAR_07_2 = 'SAR 07.2'
NAME_SAR_07_6 = 'SAR 07.6'
NAME_SAR_10_2 = 'SAR 10.2'
NAME_SAR_14_2 = 'SAR 14.2'
NAME_SAR_14_6 = 'SAR 14.6'
NAME_SAR_16_2 = 'SAR 16.2'
NAME_SAR_25_1 = 'SAR 25.1'
NAME_SAR_30_1 = 'SAR 30.1'

NAME_AC_01_2 = 'AC 01.2'
# AC 01.1 - не выпускается (Рудакова, 02.04.2020)
NAME_AM_01_1 = 'AM 01.1'
NAME_AM_02_1 = 'AM 02.1'

FLANGE_F07 = 'F07'
FLANGE_F10 = 'F10'
FLANGE_F14 = 'F14'
FLANGE_F16 = 'F16'
FLANGE_F25 = 'F25'
FLANGE_F30 = 'F30'
FLANGE_F35 = 'F35'
FLANGE_F40 = 'F40'
FLANGE_F48 = 'F48'


def rps(rpm: float) -> float:
    return rpm / 60


RPS_4 = rps(4)
RPS_5_6 = rps(5.6)
RPS_8 = rps(8)
RPS_11 = rps(11)
RPS_16 = rps(16)
RPS_22 = rps(22)
RPS_32 = rps(32)
RPS_45 = rps(45)
RPS_63 = rps(63)
RPS_90 = rps(90)
RPS_125 = rps(125)
RPS_180 = rps(180)

AUMA_SA: Tuple[Tuple[Auma, ...], ...] = (
    (
        Auma(name=NAME_SA_07_2, speed=RPS_4, powers=(0.02e3, 0.01e3),
             min_torque=10, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_2, speed=RPS_5_6, powers=(0.02e3, 0.01e3),
             min_torque=10, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_2, speed=RPS_8, powers=(0.04e3, 0.03e3),
             min_torque=10, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_2, speed=RPS_11, powers=(0.04e3, 0.03e3),
             min_torque=10, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_2, speed=RPS_16, powers=(0.06e3, 0.04e3),
             min_torque=10, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_2, speed=RPS_22, powers=(0.06e3, 0.04e3),
             min_torque=10, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_2, speed=RPS_32, powers=(0.1e3, 0.07e3),
             min_torque=10, max_torques=(30, 20), flange=FLANGE_F10,
             mass=20, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_2, speed=RPS_45, powers=(0.1e3, 0.07e3),
             min_torque=10, max_torques=(30, 20), flange=FLANGE_F10,
             mass=20, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_2, speed=RPS_63, powers=(0.2e3, 0.14e3),
             min_torque=10, max_torques=(30, 20), flange=FLANGE_F10,
             mass=20, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_2, speed=RPS_90, powers=(0.2e3, 0.14e3),
             min_torque=10, max_torques=(30, 20), flange=FLANGE_F10,
             mass=20, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_2, speed=RPS_125, powers=(0.3e3, 0.21e3),
             min_torque=10, max_torques=(30, 20), flange=FLANGE_F10,
             mass=20, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_2, speed=RPS_180, powers=(0.3e3, 0.21e3),
             min_torque=10, max_torques=(25, 20), flange=FLANGE_F10,
             mass=20, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SA_07_6, speed=RPS_4, powers=(0.03e3, 0.02e3),
             min_torque=20, max_torques=(60, 40), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_6, speed=RPS_5_6, powers=(0.03e3, 0.02e3),
             min_torque=20, max_torques=(60, 40), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_6, speed=RPS_8, powers=(0.06e3, 0.04e3),
             min_torque=20, max_torques=(60, 40), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_6, speed=RPS_11, powers=(0.06e3, 0.04e3),
             min_torque=20, max_torques=(60, 40), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_6, speed=RPS_16, powers=(0.12e3, 0.08e3),
             min_torque=20, max_torques=(60, 40), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_6, speed=RPS_22, powers=(0.12e3, 0.08e3),
             min_torque=20, max_torques=(60, 40), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_6, speed=RPS_32, powers=(0.2e3, 0.14e3),
             min_torque=20, max_torques=(60, 40), flange=FLANGE_F10,
             mass=21, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_6, speed=RPS_45, powers=(0.2e3, 0.14e3),
             min_torque=20, max_torques=(60, 40), flange=FLANGE_F10,
             mass=21, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_6, speed=RPS_63, powers=(0.4e3, 0.28e3),
             min_torque=20, max_torques=(60, 40), flange=FLANGE_F10,
             mass=21, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_6, speed=RPS_90, powers=(0.4e3, 0.28e3),
             min_torque=20, max_torques=(60, 40), flange=FLANGE_F10,
             mass=21, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_6, speed=RPS_125, powers=(0.5e3, 0.35e3),
             min_torque=20, max_torques=(60, 40), flange=FLANGE_F10,
             mass=21, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_07_6, speed=RPS_180, powers=(0.5e3, 0.35e3),
             min_torque=20, max_torques=(50, 30), flange=FLANGE_F10,
             mass=21, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SA_10_2, speed=RPS_4, powers=(0.06e3, 0.04e3),
             min_torque=40, max_torques=(120, 90), flange=FLANGE_F10,
             mass=23, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_10_2, speed=RPS_5_6, powers=(0.06e3, 0.04e3),
             min_torque=40, max_torques=(120, 90), flange=FLANGE_F10,
             mass=23, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_10_2, speed=RPS_8, powers=(0.12e3, 0.08e3),
             min_torque=40, max_torques=(120, 90), flange=FLANGE_F10,
             mass=23, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_10_2, speed=RPS_11, powers=(0.12e3, 0.08e3),
             min_torque=40, max_torques=(120, 90), flange=FLANGE_F10,
             mass=23, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_10_2, speed=RPS_16, powers=(0.25e3, 0.17e3),
             min_torque=40, max_torques=(120, 90), flange=FLANGE_F10,
             mass=23, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_10_2, speed=RPS_22, powers=(0.25e3, 0.17e3),
             min_torque=40, max_torques=(120, 90), flange=FLANGE_F10,
             mass=23, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_10_2, speed=RPS_32, powers=(0.4e3, 0.28e3),
             min_torque=40, max_torques=(120, 90), flange=FLANGE_F10,
             mass=25, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_10_2, speed=RPS_45, powers=(0.4e3, 0.28e3),
             min_torque=40, max_torques=(120, 90), flange=FLANGE_F10,
             mass=25, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_10_2, speed=RPS_63, powers=(0.7e3, 0.5e3),
             min_torque=40, max_torques=(120, 90), flange=FLANGE_F10,
             mass=26, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_10_2, speed=RPS_90, powers=(0.7e3, 0.5e3),
             min_torque=40, max_torques=(120, 90), flange=FLANGE_F10,
             mass=26, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_10_2, speed=RPS_125, powers=(1e3, 0.7e3),
             min_torque=40, max_torques=(120, 90), flange=FLANGE_F10,
             mass=26, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_10_2, speed=RPS_180, powers=(1e3, 0.7e3),
             min_torque=40, max_torques=(100, 70), flange=FLANGE_F10,
             mass=26, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SA_14_2, speed=RPS_4, powers=(0.12e3, 0.08e3),
             min_torque=100, max_torques=(250, 180), flange=FLANGE_F14,
             mass=47, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_2, speed=RPS_5_6, powers=(0.12e3, 0.08e3),
             min_torque=100, max_torques=(250, 180), flange=FLANGE_F14,
             mass=47, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_2, speed=RPS_8, powers=(0.25e3, 0.18e3),
             min_torque=100, max_torques=(250, 180), flange=FLANGE_F14,
             mass=47, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_2, speed=RPS_11, powers=(0.25e3, 0.18e3),
             min_torque=100, max_torques=(250, 180), flange=FLANGE_F14,
             mass=47, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_2, speed=RPS_16, powers=(0.45e3, 0.3e3),
             min_torque=100, max_torques=(250, 180), flange=FLANGE_F14,
             mass=48, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_2, speed=RPS_22, powers=(0.45e3, 0.3e3),
             min_torque=100, max_torques=(250, 180), flange=FLANGE_F14,
             mass=48, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_2, speed=RPS_32, powers=(0.75e3, 0.5e3),
             min_torque=100, max_torques=(250, 180), flange=FLANGE_F14,
             mass=51, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_2, speed=RPS_45, powers=(0.75e3, 0.5e3),
             min_torque=100, max_torques=(250, 180), flange=FLANGE_F14,
             mass=51, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_2, speed=RPS_63, powers=(1.4e3, 1e3),
             min_torque=100, max_torques=(250, 180), flange=FLANGE_F14,
             mass=52, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_2, speed=RPS_90, powers=(1.4e3, 1e3),
             min_torque=100, max_torques=(250, 180), flange=FLANGE_F14,
             mass=52, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_2, speed=RPS_125, powers=(1.8e3, 1.3e3),
             min_torque=100, max_torques=(250, 180), flange=FLANGE_F14,
             mass=52, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_2, speed=RPS_180, powers=(1.8e3, 1.3e3),
             min_torque=100, max_torques=(200, 140), flange=FLANGE_F14,
             mass=52, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SA_14_6, speed=RPS_4, powers=(0.2e3, 0.14e3),
             min_torque=200, max_torques=(500, 360), flange=FLANGE_F14,
             mass=49, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_6, speed=RPS_5_6, powers=(0.2e3, 0.14e3),
             min_torque=200, max_torques=(500, 360), flange=FLANGE_F14,
             mass=49, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_6, speed=RPS_8, powers=(0.4e3, 0.3e3),
             min_torque=200, max_torques=(500, 360), flange=FLANGE_F14,
             mass=49, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_6, speed=RPS_11, powers=(0.4e3, 0.3e3),
             min_torque=200, max_torques=(500, 360), flange=FLANGE_F14,
             mass=49, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_6, speed=RPS_16, powers=(0.8e3, 0.6e3),
             min_torque=200, max_torques=(500, 360), flange=FLANGE_F14,
             mass=50, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_6, speed=RPS_22, powers=(0.8e3, 0.6e3),
             min_torque=200, max_torques=(500, 360), flange=FLANGE_F14,
             mass=50, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_6, speed=RPS_32, powers=(1.6e3, 1e3),
             min_torque=200, max_torques=(500, 360), flange=FLANGE_F14,
             mass=57, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_6, speed=RPS_45, powers=(1.6e3, 1e3),
             min_torque=200, max_torques=(500, 360), flange=FLANGE_F14,
             mass=57, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_6, speed=RPS_63, powers=(3e3, 2e3),
             min_torque=200, max_torques=(500, 360), flange=FLANGE_F14,
             mass=57, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_6, speed=RPS_90, powers=(3e3, 2e3),
             min_torque=200, max_torques=(500, 360), flange=FLANGE_F14,
             mass=57, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_6, speed=RPS_125, powers=(3.3e3, 2.3e3),
             min_torque=200, max_torques=(500, 360), flange=FLANGE_F14,
             mass=57, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_14_6, speed=RPS_180, powers=(3.3e3, 2.3e3),
             min_torque=200, max_torques=(400, 290), flange=FLANGE_F14,
             mass=57, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SA_16_2, speed=RPS_4, powers=(0.4e3, 0.3e3),
             min_torque=400, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=75, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_16_2, speed=RPS_5_6, powers=(0.4e3, 0.3e3),
             min_torque=400, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=75, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_16_2, speed=RPS_8, powers=(0.8e3, 0.6e3),
             min_torque=400, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=75, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_16_2, speed=RPS_11, powers=(0.8e3, 0.6e3),
             min_torque=400, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=75, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_16_2, speed=RPS_16, powers=(1.5e3, 1e3),
             min_torque=400, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=75, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_16_2, speed=RPS_22, powers=(1.5e3, 1e3),
             min_torque=400, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=75, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_16_2, speed=RPS_32, powers=(3e3, 2e3),
             min_torque=400, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=86, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_16_2, speed=RPS_45, powers=(3e3, 2e3),
             min_torque=400, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=86, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_16_2, speed=RPS_63, powers=(5e3, 3.5e3),
             min_torque=400, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=91, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_16_2, speed=RPS_90, powers=(5e3, 3.5e3),
             min_torque=400, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=91, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_16_2, speed=RPS_125, powers=(6e3, 4e3),
             min_torque=400, max_torques=(800, 570), flange=FLANGE_F16,
             mass=91, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_16_2, speed=RPS_180, powers=(6e3, 4e3),
             min_torque=400, max_torques=(800, 570), flange=FLANGE_F16,
             mass=91, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SA_25_1, speed=RPS_4, powers=(1.1e3, 0.75e3),
             min_torque=630, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=150, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_25_1, speed=RPS_5_6, powers=(1.1e3, 0.75e3),
             min_torque=630, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=150, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_25_1, speed=RPS_8, powers=(3e3, 2.2e3),
             min_torque=630, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=150, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_25_1, speed=RPS_11, powers=(3e3, 2.2e3),
             min_torque=630, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=150, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_25_1, speed=RPS_16, powers=(4e3, 3e3),
             min_torque=630, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=150, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_25_1, speed=RPS_22, powers=(4e3, 3e3),
             min_torque=630, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=150, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_25_1, speed=RPS_32, powers=(7.5e3, 5.5e3),
             min_torque=630, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=160, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_25_1, speed=RPS_45, powers=(7.5e3, 5.5e3),
             min_torque=630, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=160, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_25_1, speed=RPS_63, powers=(15e3, 11e3),
             min_torque=630, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=160, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_25_1, speed=RPS_90, powers=(15e3, 11e3),
             min_torque=630, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=160, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SA_30_1, speed=RPS_4, powers=(2.2e3, 1.5e3),
             min_torque=1250, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=190, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_30_1, speed=RPS_5_6, powers=(2.2e3, 1.5e3),
             min_torque=1250, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=190, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_30_1, speed=RPS_8, powers=(5.5e3, 4e3),
             min_torque=1250, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=190, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_30_1, speed=RPS_11, powers=(5.5e3, 4e3),
             min_torque=1250, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=190, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_30_1, speed=RPS_16, powers=(7.5e3, 5.5e3),
             min_torque=1250, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=190, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_30_1, speed=RPS_22, powers=(7.5e3, 5.5e3),
             min_torque=1250, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=190, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_30_1, speed=RPS_32, powers=(15e3, 11e3),
             min_torque=1250, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=260, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_30_1, speed=RPS_45, powers=(15e3, 11e3),
             min_torque=1250, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=260, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_30_1, speed=RPS_63, powers=(30e3, 22e3),
             min_torque=1250, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=260, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_30_1, speed=RPS_90, powers=(30e3, 22e3),
             min_torque=1250, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=260, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SA_35_1, speed=RPS_4, powers=(4e3, 3e3),
             min_torque=2500, max_torques=(8000, 5700), flange=FLANGE_F35,
             mass=410, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_35_1, speed=RPS_5_6, powers=(4e3, 3e3),
             min_torque=2500, max_torques=(8000, 5700), flange=FLANGE_F35,
             mass=410, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_35_1, speed=RPS_8, powers=(7.5e3, 5.5e3),
             min_torque=2500, max_torques=(8000, 5700), flange=FLANGE_F35,
             mass=410, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_35_1, speed=RPS_11, powers=(7.5e3, 5.5e3),
             min_torque=2500, max_torques=(8000, 5700), flange=FLANGE_F35,
             mass=410, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_35_1, speed=RPS_16, powers=(15e3, 11e3),
             min_torque=2500, max_torques=(8000, 5700), flange=FLANGE_F35,
             mass=410, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_35_1, speed=RPS_22, powers=(15e3, 11e3),
             min_torque=2500, max_torques=(8000, 5700), flange=FLANGE_F35,
             mass=410, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_35_1, speed=RPS_32, powers=(30e3, 14e3),
             min_torque=2500, max_torques=(8000, 5700), flange=FLANGE_F35,
             mass=425, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_35_1, speed=RPS_45, powers=(30e3, 14e3),
             min_torque=2500, max_torques=(8000, 5700), flange=FLANGE_F35,
             mass=425, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SA_40_1, speed=RPS_4, powers=(7.5e3, 5.5e3),
             min_torque=5000, max_torques=(16000, 11200), flange=FLANGE_F40,
             mass=510, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_40_1, speed=RPS_5_6, powers=(7.5e3, 5.5e3),
             min_torque=5000, max_torques=(16000, 11200), flange=FLANGE_F40,
             mass=510, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_40_1, speed=RPS_8, powers=(15e3, 11e3),
             min_torque=5000, max_torques=(16000, 11200), flange=FLANGE_F40,
             mass=510, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_40_1, speed=RPS_11, powers=(15e3, 11e3),
             min_torque=5000, max_torques=(16000, 11200), flange=FLANGE_F40,
             mass=510, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_40_1, speed=RPS_16, powers=(30e3, 22e3),
             min_torque=5000, max_torques=(16000, 11200), flange=FLANGE_F40,
             mass=510, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_40_1, speed=RPS_22, powers=(30e3, 22e3),
             min_torque=5000, max_torques=(16000, 11200), flange=FLANGE_F40,
             mass=510, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_40_1, speed=RPS_32, powers=(30e3, 22e3),
             min_torque=5000, max_torques=(14000, 9800), flange=FLANGE_F40,
             mass=510, selflock=False, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SA_48_1, speed=RPS_4, powers=(15e3, 11e3),
             min_torque=10000, max_torques=(32000, 22400), flange=FLANGE_F48,
             mass=750, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_48_1, speed=RPS_5_6, powers=(15e3, 11e3),
             min_torque=10000, max_torques=(32000, 22400), flange=FLANGE_F48,
             mass=750, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_48_1, speed=RPS_8, powers=(30e3, 22e3),
             min_torque=10000, max_torques=(32000, 22400), flange=FLANGE_F48,
             mass=750, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_48_1, speed=RPS_11, powers=(30e3, 22e3),
             min_torque=10000, max_torques=(32000, 22400), flange=FLANGE_F48,
             mass=750, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SA_48_1, speed=RPS_16, powers=(45e3, 30e3),
             min_torque=10000, max_torques=(32000, 22400), flange=FLANGE_F48,
             mass=750, selflock=True, mode_names=SA_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)))
)

AUMA_SAR: Tuple[Tuple[Auma, ...], ...] = (
    (
        Auma(name=NAME_SAR_07_2, speed=RPS_4, powers=(0.02e3, 0.01e3),
             min_torque=15, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_2, speed=RPS_5_6, powers=(0.02e3, 0.01e3),
             min_torque=15, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_2, speed=RPS_8, powers=(0.04e3, 0.03e3),
             min_torque=15, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_2, speed=RPS_11, powers=(0.04e3, 0.03e3),
             min_torque=15, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_2, speed=RPS_16, powers=(0.06e3, 0.04e3),
             min_torque=15, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_2, speed=RPS_22, powers=(0.06e3, 0.04e3),
             min_torque=15, max_torques=(30, 20), flange=FLANGE_F07,
             mass=19, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_2, speed=RPS_32, powers=(0.1e3, 0.07e3),
             min_torque=15, max_torques=(30, 20), flange=FLANGE_F10,
             mass=20, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_2, speed=RPS_45, powers=(0.1e3, 0.07e3),
             min_torque=15, max_torques=(30, 20), flange=FLANGE_F10,
             mass=20, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_2, speed=RPS_63, powers=(0.2e3, 0.14e3),
             min_torque=15, max_torques=(30, 20), flange=FLANGE_F10,
             mass=20, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_2, speed=RPS_90, powers=(0.2e3, 0.14e3),
             min_torque=15, max_torques=(30, 20), flange=FLANGE_F10,
             mass=20, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SAR_07_6, speed=RPS_4, powers=(0.03e3, 0.02e3),
             min_torque=30, max_torques=(60, 40), flange=FLANGE_F07,
             mass=20, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_6, speed=RPS_5_6, powers=(0.03e3, 0.02e3),
             min_torque=30, max_torques=(60, 40), flange=FLANGE_F07,
             mass=20, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_6, speed=RPS_8, powers=(0.06e3, 0.04e3),
             min_torque=30, max_torques=(60, 40), flange=FLANGE_F07,
             mass=20, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_6, speed=RPS_11, powers=(0.06e3, 0.04e3),
             min_torque=30, max_torques=(60, 40), flange=FLANGE_F07,
             mass=20, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_6, speed=RPS_16, powers=(0.12e3, 0.08e3),
             min_torque=30, max_torques=(60, 40), flange=FLANGE_F07,
             mass=20, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_6, speed=RPS_22, powers=(0.12e3, 0.08e3),
             min_torque=30, max_torques=(60, 40), flange=FLANGE_F07,
             mass=20, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_6, speed=RPS_32, powers=(0.2e3, 0.14e3),
             min_torque=30, max_torques=(60, 40), flange=FLANGE_F10,
             mass=21, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_6, speed=RPS_45, powers=(0.2e3, 0.14e3),
             min_torque=30, max_torques=(60, 40), flange=FLANGE_F10,
             mass=21, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_6, speed=RPS_63, powers=(0.4e3, 0.28e3),
             min_torque=30, max_torques=(60, 40), flange=FLANGE_F10,
             mass=21, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_07_6, speed=RPS_90, powers=(0.4e3, 0.28e3),
             min_torque=30, max_torques=(60, 40), flange=FLANGE_F10,
             mass=21, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SAR_10_2, speed=RPS_4, powers=(0.06e3, 0.04e3),
             min_torque=60, max_torques=(120, 90), flange=FLANGE_F10,
             mass=22, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_10_2, speed=RPS_5_6, powers=(0.06e3, 0.04e3),
             min_torque=60, max_torques=(120, 90), flange=FLANGE_F10,
             mass=22, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_10_2, speed=RPS_8, powers=(0.12e3, 0.08e3),
             min_torque=60, max_torques=(120, 90), flange=FLANGE_F10,
             mass=22, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_10_2, speed=RPS_11, powers=(0.12e3, 0.08e3),
             min_torque=60, max_torques=(120, 90), flange=FLANGE_F10,
             mass=22, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_10_2, speed=RPS_16, powers=(0.25e3, 0.17e3),
             min_torque=60, max_torques=(120, 90), flange=FLANGE_F10,
             mass=22, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_10_2, speed=RPS_22, powers=(0.25e3, 0.17e3),
             min_torque=60, max_torques=(120, 90), flange=FLANGE_F10,
             mass=22, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_10_2, speed=RPS_32, powers=(0.4e3, 0.28e3),
             min_torque=60, max_torques=(120, 90), flange=FLANGE_F10,
             mass=25, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_10_2, speed=RPS_45, powers=(0.4e3, 0.28e3),
             min_torque=60, max_torques=(120, 90), flange=FLANGE_F10,
             mass=25, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_10_2, speed=RPS_63, powers=(0.7e3, 0.5e3),
             min_torque=60, max_torques=(120, 90), flange=FLANGE_F10,
             mass=25, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_10_2, speed=RPS_90, powers=(0.7e3, 0.5e3),
             min_torque=60, max_torques=(120, 90), flange=FLANGE_F10,
             mass=25, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_01_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SAR_14_2, speed=RPS_4, powers=(0.12e3, 0.08e3),
             min_torque=120, max_torques=(250, 180), flange=FLANGE_F14,
             mass=44, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_2, speed=RPS_5_6, powers=(0.12e3, 0.08e3),
             min_torque=120, max_torques=(250, 180), flange=FLANGE_F14,
             mass=44, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_2, speed=RPS_8, powers=(0.25e3, 0.18e3),
             min_torque=120, max_torques=(250, 180), flange=FLANGE_F14,
             mass=44, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_2, speed=RPS_11, powers=(0.25e3, 0.18e3),
             min_torque=120, max_torques=(250, 180), flange=FLANGE_F14,
             mass=44, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_2, speed=RPS_16, powers=(0.45e3, 0.3e3),
             min_torque=120, max_torques=(250, 180), flange=FLANGE_F14,
             mass=48, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_2, speed=RPS_22, powers=(0.45e3, 0.3e3),
             min_torque=120, max_torques=(250, 180), flange=FLANGE_F14,
             mass=48, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_2, speed=RPS_32, powers=(0.75e3, 0.5e3),
             min_torque=120, max_torques=(250, 180), flange=FLANGE_F14,
             mass=48, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_2, speed=RPS_45, powers=(0.75e3, 0.5e3),
             min_torque=120, max_torques=(250, 180), flange=FLANGE_F14,
             mass=48, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_2, speed=RPS_63, powers=(1.4e3, 1e3),
             min_torque=120, max_torques=(250, 180), flange=FLANGE_F14,
             mass=48, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_2, speed=RPS_90, powers=(1.4e3, 1e3),
             min_torque=120, max_torques=(250, 180), flange=FLANGE_F14,
             mass=48, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SAR_14_6, speed=RPS_4, powers=(0.2e3, 0.14e3),
             min_torque=250, max_torques=(500, 360), flange=FLANGE_F14,
             mass=46, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_6, speed=RPS_5_6, powers=(0.2e3, 0.14e3),
             min_torque=250, max_torques=(500, 360), flange=FLANGE_F14,
             mass=46, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_6, speed=RPS_8, powers=(0.4e3, 0.3e3),
             min_torque=250, max_torques=(500, 360), flange=FLANGE_F14,
             mass=46, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_6, speed=RPS_11, powers=(0.4e3, 0.3e3),
             min_torque=250, max_torques=(500, 360), flange=FLANGE_F14,
             mass=46, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_6, speed=RPS_16, powers=(0.8e3, 0.6e3),
             min_torque=250, max_torques=(500, 360), flange=FLANGE_F14,
             mass=53, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_6, speed=RPS_22, powers=(0.8e3, 0.6e3),
             min_torque=250, max_torques=(500, 360), flange=FLANGE_F14,
             mass=53, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_6, speed=RPS_32, powers=(1.6e3, 1e3),
             min_torque=250, max_torques=(500, 360), flange=FLANGE_F14,
             mass=53, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_6, speed=RPS_45, powers=(1.6e3, 1e3),
             min_torque=250, max_torques=(500, 360), flange=FLANGE_F14,
             mass=53, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_6, speed=RPS_63, powers=(3e3, 2e3),
             min_torque=250, max_torques=(500, 360), flange=FLANGE_F14,
             mass=53, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_14_6, speed=RPS_90, powers=(3e3, 2e3),
             min_torque=250, max_torques=(500, 360), flange=FLANGE_F14,
             mass=53, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SAR_16_2, speed=RPS_4, powers=(0.4e3, 0.3e3),
             min_torque=500, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=67, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_16_2, speed=RPS_5_6, powers=(0.4e3, 0.3e3),
             min_torque=500, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=67, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_16_2, speed=RPS_8, powers=(0.8e3, 0.6e3),
             min_torque=500, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=67, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_16_2, speed=RPS_11, powers=(0.8e3, 0.6e3),
             min_torque=500, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=67, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_16_2, speed=RPS_16, powers=(1.5e3, 1e3),
             min_torque=500, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=67, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_16_2, speed=RPS_22, powers=(1.5e3, 1e3),
             min_torque=500, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=67, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_16_2, speed=RPS_32, powers=(3e3, 2e3),
             min_torque=500, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=79, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_16_2, speed=RPS_45, powers=(3e3, 2e3),
             min_torque=500, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=79, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_16_2, speed=RPS_63, powers=(5e3, 3.5e3),
             min_torque=500, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=82, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_16_2, speed=RPS_90, powers=(5e3, 3.5e3),
             min_torque=500, max_torques=(1000, 710), flange=FLANGE_F16,
             mass=82, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SAR_25_1, speed=RPS_4, powers=(1.1e3, 0.75e3),
             min_torque=1000, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=150, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_25_1, speed=RPS_5_6, powers=(1.1e3, 0.75e3),
             min_torque=1000, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=150, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_25_1, speed=RPS_8, powers=(3e3, 2.2e3),
             min_torque=1000, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=150, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_25_1, speed=RPS_11, powers=(3e3, 2.2e3),
             min_torque=1000, max_torques=(2000, 1400), flange=FLANGE_F25,
             mass=150, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2))),
    (
        Auma(name=NAME_SAR_30_1, speed=RPS_4, powers=(2.2e3, 1.5e3),
             min_torque=2000, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=190, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_30_1, speed=RPS_5_6, powers=(2.2e3, 1.5e3),
             min_torque=2000, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=190, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_30_1, speed=RPS_8, powers=(5.5e3, 4e3),
             min_torque=2000, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=190, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)),

        Auma(name=NAME_SAR_30_1, speed=RPS_11, powers=(5.5e3, 4e3),
             min_torque=2000, max_torques=(4000, 2800), flange=FLANGE_F30,
             mass=190, selflock=True, mode_names=SAR_MODE_NAMES,
             control_names=(NAME_AM_02_1, NAME_AC_01_2)))
)

AUMA_GK = (
    RightAngleGearbox(name='GK 10.2', max_torque=120, ratio=1,
                      flange=FLANGE_F10, mass=8.5),
    RightAngleGearbox(name='GK 14.2', max_torque=250, ratio=2,
                      flange=FLANGE_F14, mass=15),
    RightAngleGearbox(name='GK 14.6', max_torque=500, ratio=2.8,
                      flange=FLANGE_F14, mass=15),
    RightAngleGearbox(name='GK 16.2', max_torque=1000, ratio=4,
                      flange=FLANGE_F16, mass=25),
    RightAngleGearbox(name='GK 25.2', max_torque=2000, ratio=5.6,
                      flange=FLANGE_F25, mass=60),
    RightAngleGearbox(name='GK 30.2', max_torque=4000, ratio=8,
                      flange=FLANGE_F30, mass=110),
    RightAngleGearbox(name='GK 35.2', max_torque=8000, ratio=11,
                      flange=FLANGE_F35, mass=190),
    RightAngleGearbox(name='GK 40.2', max_torque=16000, ratio=16,
                      flange=FLANGE_F40, mass=250),
)

TRAMEC_RAC = (
    RightAngleGearbox(name='RA 19', max_torque=35, ratio=1, flange=None,
                      mass=8.5),
    RightAngleGearbox(name='RA 24', max_torque=73, ratio=1, flange=None,
                      mass=14),
    RightAngleGearbox(name='RA 28', max_torque=146, ratio=1, flange=None,
                      mass=23),
    RightAngleGearbox(name='RA 38', max_torque=291, ratio=1, flange=None,
                      mass=38),
    RightAngleGearbox(name='RA 48', max_torque=596, ratio=1, flange=None,
                      mass=62),
)
