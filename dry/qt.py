import os
from typing import Optional, Tuple, Callable, Union
from PyQt5.QtWidgets import QLineEdit, QMessageBox
from .core import get_translate, InputException, get_dir_current_file


_ = get_translate(get_dir_current_file(__file__), 'ru', 'common')


AnyNumber = Union[int, float]
Limit = Optional[Tuple[AnyNumber, bool]]  # (limit, maybe_equal)


def get_number(lineedit: QLineEdit, min_limit: Limit, max_limit: Limit,
               out_type: Callable[[str], AnyNumber]=float) -> AnyNumber:
    text = lineedit.text().replace(',', '.')
    try:
        number = out_type(text)
    except ValueError:
        stop_in_lineedit(lineedit, _('Incorrect string format'))
    if min_limit is not None and (
            number < min_limit[0] if min_limit[1] else
            number <= min_limit[0]):
        stop_in_lineedit(lineedit, _('Too small value'))
    if max_limit is not None and (
            number > max_limit[0] if max_limit[1] else
            number >= max_limit[0]):
        stop_in_lineedit(lineedit, _('Too big value'))
    return number


def stop_in_lineedit(lineedit: QLineEdit, warning: str) -> None:
    lineedit.setFocus()
    lineedit.selectAll()
    raise InputException(warning)


def msgbox(warning: str) -> None:
    QMessageBox(QMessageBox.Critical, _('Error'), warning).exec()
