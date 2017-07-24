#!/usr/bin/env python3
import sys
from math import pi
from PyQt5 import QtWidgets
from PyQt5.QtGui import QTextCursor
from PyQt5.QtCore import Qt
import gui
from output import output_result
from slg import SlgKind, Drive, Install, MotorControl, DEFAULT_PITCH
from slidegate import Slidegate
from version import __version__
from slg3 import mass_calculation
from auma import AUMA_SA, AUMA_GK, AUMA_SAR
sys.path.append('..')
from dry.qt import get_number, msgbox
from dry.core import Error


class MainWindow(QtWidgets.QDialog, gui.Ui_Dialog):
    def __init__(self, parent=None):
        super(MainWindow, self).__init__(
            parent, flags=Qt.WindowMinimizeButtonHint |
            Qt.WindowCloseButtonHint)
        self.setupUi(self)
        self.setWindowTitle('{0} (v{1})'.format(self.windowTitle(),
                                                __version__))
        self._set_fixed_minimal_size()

        self.motors = (AUMA_SA, AUMA_SAR)
        for motors in self.motors:
            for i in motors:
                self.cmb_auma.addItems('{0}  {1:g} об/мин'.format(
                    j.name, j.speed * 60) for j in i)

        self.cmb_reducer.addItems(i.name for i in AUMA_GK)

        self._connect_actions()
        self.slg = None

    def _set_fixed_minimal_size(self):
        self.layout().setSizeConstraint(QtWidgets.QLayout.SetFixedSize)
        self.setFixedSize(self.geometry().width(), self.geometry().height())

    def _connect_actions(self):
        self.btn_run.clicked.connect(self._run)
        self.rad_kind_deep.toggled.connect(self._toggle_hydr_head)
        self.rad_kind_flow.toggled.connect(self._toggle_flow)
        self.rad_kind_flow.toggled.connect(self._toggle_screw_pullout)
        self.rad_lang_ru.toggled.connect(self._output_results)
        self.rad_lang_en.toggled.connect(self._output_results)

    def _toggle_hydr_head(self):
        is_need_head = self.rad_kind_deep.isChecked()
        self.lab_hydr_head.setEnabled(is_need_head)
        self.edt_hydr_head.setEnabled(is_need_head)

    def _toggle_flow(self):
        self.grp_flow.setEnabled(self.rad_kind_flow.isChecked())

    def _toggle_screw_pullout(self):
        self.chk_is_screw_pullout.setEnabled(
            not self.rad_kind_flow.isChecked())

    def _run(self):
        prev = self.slg
        try:
            self._calc()
        except Error as err:
            self.slg = prev
            self.txt_result.clear()
            msgbox(str(err))
        else:
            self._output_results()

    def _calc(self):
        frame_width = get_number(self.edt_frame_width, (0, False), None)

        frame_height = None
        if self.edt_frame_height.text():
            frame_height = get_number(
                self.edt_frame_height, (0, False), None)

        gate_height = get_number(self.edt_gate_height, (0, False), None)

        install = Install(self.cmb_install.currentIndex())

        is_frame_closed = self.chk_closed_frame.isChecked()

        screw_diam = None
        if self.edt_screw.text():
            screw_diam = get_number(
                self.edt_screw, (DEFAULT_PITCH * 1e3, False), None) / 1e3

        way = None
        if self.edt_way.text():
            way = get_number(self.edt_way, (0, False), None)

        have_rack = self.grp_rack.isChecked()

        beth_frame_top_and_gate_top = None
        if self.grp_rack.isChecked():
            beth_frame_top_and_gate_top = \
                get_number(self.edt_rack_dist, (0, False), None)

        have_fixed_gate = None
        if self.rad_kind_deep.isChecked():
            kind = SlgKind.deep
            hydr_head = get_number(self.edt_hydr_head, (0, False), None)
        else:
            hydr_head = gate_height
            if self.rad_kind_flow.isChecked():
                kind = SlgKind.flow
                have_fixed_gate = self.chk_fixed_gate.isChecked()
                beth_frame_top_and_gate_top = \
                    get_number(self.edt_flow_dist, (0, False), None)
            else:
                kind = SlgKind.surf

        if self.chk_screws_number.isChecked():
            screws_number = 2
        else:
            screws_number = 1

        if self.rad_drive_electric.isChecked():
            drive = Drive.electric
        elif self.rad_drive_reducer.isChecked():
            drive = Drive.reducer
        else:
            drive = Drive.manual

        is_screw_pullout = self.rad_kind_flow.isChecked() or \
            self.chk_is_screw_pullout.isChecked()

        liquid_density = get_number(self.edt_density, (0, False), None)

        motor_control = None
        if self.grp_motor_control.isChecked():
            if self.rad_simple_control.isChecked():
                motor_control = MotorControl.simple
            else:
                motor_control = MotorControl.extended

        have_nodes_in_frame = None
        if self.rad_have_nodes_in_frame_none.isChecked():
            have_nodes_in_frame = False

        wedges_pairs_number = None
        if self.rad_wedge_pairs_three.isChecked():
            wedges_pairs_number = 3

        auma = None
        index = self.cmb_auma.currentIndex()
        if index:
            motors = (k for i in self.motors for j in i for k in j)
            while index:
                auma = next(motors)
                index -= 1

        reducer = None
        index_gk = self.cmb_reducer.currentIndex()
        if index_gk:
            reducer = AUMA_GK[index_gk - 1]

        self.slg = Slidegate(
            frame_width=frame_width,
            gate_height=gate_height,
            hydr_head=hydr_head,
            kind=kind,
            drive=drive,
            install=install,
            is_frame_closed=is_frame_closed,
            have_rack=have_rack,
            is_screw_pullout=is_screw_pullout,
            tilt_angle=pi / 2,
            screws_number=screws_number,
            liquid_density=liquid_density,
            have_fixed_gate=have_fixed_gate,
            frame_height=frame_height,
            have_nodes_in_frame=have_nodes_in_frame,
            wedges_pairs_number=wedges_pairs_number,
            motor_control=motor_control,
            is_left_hand_closing=None,
            way=way,
            screw_diam=screw_diam,
            reducer=reducer,
            auma=auma,
            beth_frame_top_and_gate_top=beth_frame_top_and_gate_top
        )
        mass_calculation(self.slg)

    def _output_results(self):
        if self.slg:
            self.txt_result.clear()
            if self.rad_lang_ru.isChecked():
                lang = 'ru'
            else:
                lang = ''
            self.txt_result.appendPlainText(output_result(self.slg, lang))
            cursor = self.txt_result.textCursor()
            cursor.movePosition(QTextCursor.Start, QTextCursor.MoveAnchor, 1)
            self.txt_result.setTextCursor(cursor)


def main(classname):
    app = QtWidgets.QApplication(sys.argv)
    form = classname()
    form.show()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main(MainWindow)
