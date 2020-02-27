import os
import sys
import gettext
import math
from typing import Callable


# Ускорение свободного падения, м/с2
GRAV_ACCELERATION = 9.80665


class Error(Exception):
    pass


class InputException(Error):
    pass


def get_dir_current_file(filename: str) -> str:
    if getattr(sys, 'frozen', False):
        filename = sys.executable
    return os.path.dirname(filename)


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


# кгс -> СИ
# TODO: rename 'from_kgf'
def to_n(kgf: float) -> float:
    return kgf * GRAV_ACCELERATION


# Площадь круга
def compute_area_circle(diameter: float) -> float:
    return math.pi * diameter**2 / 4


# Проверка четности числа
def is_even(number: int) -> bool:
    return number % 2 == 0


# Ближайшее четное
def nearest_even(number: float) -> int:
    rounded_number = round(number)
    if is_even(rounded_number):
        to_even = 0
    else:
        to_even = int(math.copysign(1, number - rounded_number))
    return rounded_number + to_even
