from math import pi, ceil

G = 9.80665


# Return minimal rod inertia moment by axial force and its elasticity
# 0.5 <= mju <= 2.0
def min_inertia_moment(axial_force: float, fos: float, rod_length: float,
                       rod_elast: float, mju: float) -> float:
    return axial_force * fos * (mju * rod_length / pi)**2 / rod_elast


# The calculation of cross-section diameter by its moment of inertia.
def diam_by_inertia_moment(moment_iner: float) -> float:
    return (moment_iner * 64 / pi)**0.25


# Return axial inertia moment of circular section by its diameter
def axial_inertia_moment(diam: float) -> float:
    return pi * diam**4 / 64


# Calculation factor of safity in screw by axial force
def fos_calc(screw_minor_diam: float, screw_length: float, screw_elast: float,
             axial_force: float, mju: float) -> float:
    return (axial_inertia_moment(screw_minor_diam) * screw_elast / axial_force
            / (mju * screw_length / pi)**2)


def diam_circle_by_area(area: float) -> float:
    return (4 * area / pi)**0.5


def diam_circle_by_force_shear(force: float, limit: float) -> float:
    return diam_circle_by_area(force / limit)


def area_circle_of_diam(diam: float, angle: float = 2 * pi) -> float:
    return angle * diam**2 / 8


def area_ring_of_diam(major_diam: float, minor_diam: float,
                      angle: float) -> float:
    return area_circle_of_diam(major_diam, angle) - \
        area_circle_of_diam(minor_diam, angle)


def ceilto(number: float, multiplicity: float) -> float:
    return ceil(number / multiplicity) * multiplicity


def roundu(num: float) -> int:
    return int(num + 0.5)
