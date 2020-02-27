from enum import IntEnum, unique


LIMIT_SHEAR_STRESS = 75e6  # Pa


@unique
class SlgKind(IntEnum):
    deep, surf, flow = range(3)


@unique
class Drive(IntEnum):
    manual, electric, reducer = range(3)


@unique
class Install(IntEnum):
    concrete, channel, wall, flange, twoflange = range(5)


# AUMA MATIC - AM
# 07.2-10.2  - AM 01.1
# 14.2-48.1  - AM 02.1
# It commands OPEN, STOP, CLOSE, shows the errors and signals about the end
# position.

# AUMATIC   - AC
# 07.2-16.2 - AC 01.2
# 25.1-40.1 - AC 01.1
# It performs the all functions of AUMA MATIC and transmits the additional
# information: working hours, temperature, vibration.

@unique
class MotorControl(IntEnum):
    simple, extended = range(2)


RADIUS = {2e-3: 2.47e-3,
          3e-3: 2.34e-3,
          4e-3: 3.78e-3,
          5e-3: 6.20e-3,
          6e-3: 7.39e-3,
          8e-3: 11.23e-3}


THICKNESS = sorted(RADIUS.keys())

RACK_THICKNESS = 0.004
