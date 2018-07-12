from typing import Optional, Tuple, TypeVar, Type, Generic, Union
from PyQt5 import QtWidgets
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QTextCursor
from .core import get_translate, InputException, get_dir_current_file


_ = get_translate(get_dir_current_file(__file__), 'ru', 'common')


AnyNumber = TypeVar('AnyNumber', int, float)
Limit = Tuple[AnyNumber, bool]  # (value of limit, can be equal)
TextWidget = Union[QtWidgets.QLineEdit, QtWidgets.QComboBox]


def get_lineedit(widget: TextWidget) -> QtWidgets.QLineEdit:
    if isinstance(widget, QtWidgets.QLineEdit):
        return widget
    return widget.lineEdit()


class GetNumber(Generic[AnyNumber]):
    @staticmethod
    def get_number(widget: TextWidget,
                   min_limit: Optional[Limit],
                   max_limit: Optional[Limit],
                   out_type: Type[AnyNumber]) -> AnyNumber:
        lineedit = get_lineedit(widget)
        text = lineedit.text().replace(',', '.')
        try:
            number = out_type(text)
        except ValueError:
            stop_in_lineedit(lineedit, _('Incorrect string format'))
        if min_limit:
            if min_limit[1]:
                if number < min_limit[0]:
                    stop_in_lineedit(lineedit, _(
                        'Input a value greater than or equal to {0}').format(
                            min_limit[0]))
            else:
                if number <= min_limit[0]:
                    stop_in_lineedit(lineedit, _(
                        'Input a value greater than {0}').format(min_limit[0]))
        if max_limit:
            if max_limit[1]:
                if number > max_limit[0]:
                    stop_in_lineedit(lineedit, _(
                        'Input a value less than or equal to {0}').format(
                            max_limit[0]))
            else:
                if number >= max_limit[0]:
                    stop_in_lineedit(lineedit, _(
                        'Input a value less than {0}').format(max_limit[0]))
        return number


def get_int_number(widget: TextWidget,
                   min_limit: Optional[Limit],
                   max_limit: Optional[Limit]) -> int:
    return GetNumber.get_number(widget, min_limit, max_limit, int)


def get_float_number(widget: TextWidget,
                     min_limit: Optional[Limit],
                     max_limit: Optional[Limit]) -> float:
    return GetNumber.get_number(widget, min_limit, max_limit, float)


def stop_in_lineedit(lineedit: QtWidgets.QLineEdit, warning: str) -> None:
    lineedit.setFocus()
    lineedit.selectAll()
    raise InputException(warning)


def msgbox(warning: str) -> None:
    QtWidgets.QMessageBox(
        QtWidgets.QMessageBox.Critical, _('Error'), warning).exec()


class BaseMainWindow(QtWidgets.QDialog):  # type: ignore
    def __init__(self, description: str, version: str) -> None:
        super().__init__(
            None, flags=Qt.WindowMinimizeButtonHint |
            Qt.WindowCloseButtonHint)
        self.setupUi(self)  # from gui.Ui_Dialog
        self.setWindowTitle(f'{description} (v{version})')
        self.init_widgets()
        self.layout().setSizeConstraint(QtWidgets.QLayout.SetFixedSize)
        self.connect_actions()


def move_cursor_to_begin(line_edit: TextWidget) -> None:
    cursor = line_edit.textCursor()
    cursor.movePosition(QTextCursor.Start, QTextCursor.MoveAnchor, 1)
    line_edit.setTextCursor(cursor)
