#!/usr/bin/env python3
import sys
from math import pi
from typing import Optional
from PyQt5 import QtWidgets
from PyQt5.QtGui import QTextCursor

from dry.qt import msgbox, BaseMainWindow, get_float_number
from dry.core import Error

import gui
from auma import AUMA_SA, AUMA_GK, AUMA_SAR, AUMA_GST
from manifest import VERSION, DESCRIPTION
from output import output_result
from slg import SlgKind, Drive, Install, MotorControl
from slg3 import mass_calculation
from slidegate import Slidegate


class MainWindow(BaseMainWindow, gui.Ui_Dialog):
    def __init__(self) -> None:
        self.motors = AUMA_SA, AUMA_SAR
        self.slg: Optional[Slidegate] = None
        BaseMainWindow.__init__(self, DESCRIPTION, VERSION)

    def init_widgets(self) -> None:
        for motors in self.motors:
            for i in motors:
                self.cmb_auma.addItems('{0}  {1:g} об/мин'.format(
                    j.name, j.speed * 60) for j in i)
        self.cmb_reducer.addItems(i.name for i in AUMA_GK)
        self.cmb_reducer.addItems(i.name for i in AUMA_GST)

    def connect_actions(self) -> None:
        self.btn_run.clicked.connect(self.run)
        self.rad_kind_deep.toggled.connect(self.toggle_hydr_head)
        self.rad_kind_flow.toggled.connect(self.toggle_flow)
        self.rad_kind_flow.toggled.connect(self.toggle_screw_pullout)
        self.rad_lang_ru.toggled.connect(self.output_results)
        self.rad_lang_en.toggled.connect(self.output_results)

    def toggle_hydr_head(self) -> None:
        is_need_head = self.rad_kind_deep.isChecked()
        self.lab_hydr_head.setEnabled(is_need_head)
        self.edt_hydr_head.setEnabled(is_need_head)

    def toggle_flow(self) -> None:
        self.grp_flow.setEnabled(self.rad_kind_flow.isChecked())

    def toggle_screw_pullout(self) -> None:
        self.chk_is_screw_pullout.setEnabled(
            not self.rad_kind_flow.isChecked())

    def run(self) -> None:
        prev = self.slg
        try:
            self.calc()
        except Error as err:
            self.slg = prev
            self.txt_result.clear()
            msgbox(str(err))
        else:
            self.output_results()

    def calc(self) -> None:
        frame_width = get_float_number(self.edt_frame_width, (0, False), None)

        frame_height = None
        if self.edt_frame_height.text():
            frame_height = get_float_number(
                self.edt_frame_height, (0, False), None)

        gate_height = get_float_number(self.edt_gate_height, (0, False), None)

        install = Install(self.cmb_install.currentIndex())

        is_frame_closed = self.chk_closed_frame.isChecked()

        screw_diam = None
        screw_pitch = None
        if self.edt_screw.text():
            # Предельные значения задаются в миллиметрах.
            screw_diam = get_float_number(
                self.edt_screw, (15, True), None) / 1e3  # 15 mm
            screw_pitch = get_float_number(
                self.edt_pitch, (2, True), (screw_diam * 1e3 / 2, True)) / 1e3

        way = None
        if self.edt_way.text():
            way = get_float_number(self.edt_way, (0, False), None)

        have_rack = self.grp_rack.isChecked()

        beth_frame_top_and_gate_top = None
        if self.grp_rack.isChecked():
            beth_frame_top_and_gate_top = \
                get_float_number(self.edt_rack_dist, (0, False), None)

        # TODO: убрать флаг have_fixed_gate, проверять тип монтажа.
        have_fixed_gate = False
        if self.rad_kind_deep.isChecked():
            kind = SlgKind.deep
            hydr_head = get_float_number(self.edt_hydr_head, (0, False), None)
            if hydr_head < gate_height:
                raise Error('Напор не должен быть меньше высоты щита.')
        else:
            hydr_head = gate_height
            if self.rad_kind_flow.isChecked():
                kind = SlgKind.flow
                if install in (Install.concrete, Install.channel):
                    have_fixed_gate = True
                elif install == Install.wall:
                    have_fixed_gate = False
                else:
                    raise Error('Регулирующие затворы монтируются в канал или на стену.')
                beth_frame_top_and_gate_top = \
                    get_float_number(self.edt_flow_dist, (0, False), None)
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
        elif self.rad_drive_spur.isChecked():
            drive = Drive.spur
        else:
            drive = Drive.manual

        is_screw_pullout = self.rad_kind_flow.isChecked() or \
            self.chk_is_screw_pullout.isChecked()

        liquid_density = get_float_number(self.edt_density, (0, False), None)

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
        index_gearbox = self.cmb_reducer.currentIndex()
        if index_gearbox == 0:
            pass
        elif index_gearbox <= len(AUMA_GK):
            reducer = AUMA_GK[index_gearbox - 1]
        else:
            index_gearbox -= len(AUMA_GK)
            reducer = AUMA_GK[index_gearbox - 1]

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
            way=way,
            screw_diam=screw_diam,
            screw_pitch=screw_pitch,
            reducer=reducer,
            auma=auma,
            beth_frame_top_and_gate_top=beth_frame_top_and_gate_top
        )
        mass_calculation(self.slg)

    def output_results(self) -> None:
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


def main(classname: type) -> None:
    app = QtWidgets.QApplication(sys.argv)
    form = classname()
    form.show()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main(MainWindow)
