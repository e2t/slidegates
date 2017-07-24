import os
import sys
import gettext
from math import pi
from typing import Callable


# Ускорение свободного падения, м/с2
GRAV_ACCELERATION = 9.80665


class Error(Exception):
    pass


class InputException(Error):
    pass


def get_dir_current_file(filename: str) -> str:
    if getattr(sys, 'frozen', False):
        result = os.path.dirname(sys.executable)
    else:
        result = os.path.dirname(filename)
    return result


def get_translate(
        dirlang: str, locale: str, mofile: str) -> Callable[[str], str]:
    pwd = os.getcwd()
    os.chdir(dirlang)
    try:
        translation = gettext.translation(mofile, 'lang/', [locale])
    except FileNotFoundError:
        result = gettext.gettext
    else:
        translation.install()
        result = translation.gettext
    os.chdir(pwd)
    return result


# СИ -> миллиметры
def to_mm(meters: float) -> float:
    return meters * 1e3


# СИ -> килограмм-сила
def to_kgf(newtons: float) -> float:
    return newtons / GRAV_ACCELERATION


# СИ -> мегапаскали
def to_mpa(pascals: float) -> float:
    return pascals / 1e6


# Площадь круга
def compute_area_circle(diameter: float) -> float:
    return pi * diameter**2 / 4
