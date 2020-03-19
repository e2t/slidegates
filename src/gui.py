# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'gui.ui'
#
# Created by: PyQt5 UI code generator 5.14.1
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_Dialog(object):
    def setupUi(self, Dialog):
        Dialog.setObjectName("Dialog")
        Dialog.resize(982, 607)
        icon = QtGui.QIcon()
        icon.addPixmap(QtGui.QPixmap("favicon.ico"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        Dialog.setWindowIcon(icon)
        self.formLayout = QtWidgets.QFormLayout(Dialog)
        self.formLayout.setObjectName("formLayout")
        self.horizontalLayout_4 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_4.setObjectName("horizontalLayout_4")
        self.verticalLayout_6 = QtWidgets.QVBoxLayout()
        self.verticalLayout_6.setObjectName("verticalLayout_6")
        self.groupBox = QtWidgets.QGroupBox(Dialog)
        self.groupBox.setObjectName("groupBox")
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout(self.groupBox)
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.verticalLayout = QtWidgets.QVBoxLayout()
        self.verticalLayout.setObjectName("verticalLayout")
        self.rad_kind_surf = QtWidgets.QRadioButton(self.groupBox)
        self.rad_kind_surf.setChecked(True)
        self.rad_kind_surf.setObjectName("rad_kind_surf")
        self.verticalLayout.addWidget(self.rad_kind_surf)
        self.rad_kind_deep = QtWidgets.QRadioButton(self.groupBox)
        self.rad_kind_deep.setObjectName("rad_kind_deep")
        self.verticalLayout.addWidget(self.rad_kind_deep)
        self.rad_kind_flow = QtWidgets.QRadioButton(self.groupBox)
        self.rad_kind_flow.setObjectName("rad_kind_flow")
        self.verticalLayout.addWidget(self.rad_kind_flow)
        self.horizontalLayout_2.addLayout(self.verticalLayout)
        self.verticalLayout_6.addWidget(self.groupBox)
        self.groupBox_2 = QtWidgets.QGroupBox(Dialog)
        self.groupBox_2.setObjectName("groupBox_2")
        self.horizontalLayout = QtWidgets.QHBoxLayout(self.groupBox_2)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.verticalLayout_2 = QtWidgets.QVBoxLayout()
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.rad_drive_electric = QtWidgets.QRadioButton(self.groupBox_2)
        self.rad_drive_electric.setChecked(True)
        self.rad_drive_electric.setObjectName("rad_drive_electric")
        self.verticalLayout_2.addWidget(self.rad_drive_electric)
        self.rad_drive_reducer = QtWidgets.QRadioButton(self.groupBox_2)
        self.rad_drive_reducer.setObjectName("rad_drive_reducer")
        self.verticalLayout_2.addWidget(self.rad_drive_reducer)
        self.rad_drive_manual = QtWidgets.QRadioButton(self.groupBox_2)
        self.rad_drive_manual.setObjectName("rad_drive_manual")
        self.verticalLayout_2.addWidget(self.rad_drive_manual)
        self.horizontalLayout.addLayout(self.verticalLayout_2)
        self.verticalLayout_6.addWidget(self.groupBox_2)
        self.grp_motor_control = QtWidgets.QGroupBox(Dialog)
        self.grp_motor_control.setCheckable(True)
        self.grp_motor_control.setChecked(False)
        self.grp_motor_control.setObjectName("grp_motor_control")
        self.horizontalLayout_8 = QtWidgets.QHBoxLayout(self.grp_motor_control)
        self.horizontalLayout_8.setObjectName("horizontalLayout_8")
        self.verticalLayout_3 = QtWidgets.QVBoxLayout()
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.rad_simple_control = QtWidgets.QRadioButton(self.grp_motor_control)
        self.rad_simple_control.setChecked(True)
        self.rad_simple_control.setObjectName("rad_simple_control")
        self.verticalLayout_3.addWidget(self.rad_simple_control)
        self.rad_extended_control = QtWidgets.QRadioButton(self.grp_motor_control)
        self.rad_extended_control.setObjectName("rad_extended_control")
        self.verticalLayout_3.addWidget(self.rad_extended_control)
        self.horizontalLayout_8.addLayout(self.verticalLayout_3)
        self.verticalLayout_6.addWidget(self.grp_motor_control)
        self.groupBox_12 = QtWidgets.QGroupBox(Dialog)
        self.groupBox_12.setObjectName("groupBox_12")
        self.horizontalLayout_16 = QtWidgets.QHBoxLayout(self.groupBox_12)
        self.horizontalLayout_16.setObjectName("horizontalLayout_16")
        self.verticalLayout_4 = QtWidgets.QVBoxLayout()
        self.verticalLayout_4.setObjectName("verticalLayout_4")
        self.cmb_install = QtWidgets.QComboBox(self.groupBox_12)
        self.cmb_install.setObjectName("cmb_install")
        self.cmb_install.addItem("")
        self.cmb_install.addItem("")
        self.cmb_install.addItem("")
        self.cmb_install.addItem("")
        self.cmb_install.addItem("")
        self.verticalLayout_4.addWidget(self.cmb_install)
        self.chk_closed_frame = QtWidgets.QCheckBox(self.groupBox_12)
        self.chk_closed_frame.setObjectName("chk_closed_frame")
        self.verticalLayout_4.addWidget(self.chk_closed_frame)
        self.horizontalLayout_16.addLayout(self.verticalLayout_4)
        self.verticalLayout_6.addWidget(self.groupBox_12)
        spacerItem = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.verticalLayout_6.addItem(spacerItem)
        self.groupBox_8 = QtWidgets.QGroupBox(Dialog)
        self.groupBox_8.setObjectName("groupBox_8")
        self.horizontalLayout_9 = QtWidgets.QHBoxLayout(self.groupBox_8)
        self.horizontalLayout_9.setObjectName("horizontalLayout_9")
        self.verticalLayout_7 = QtWidgets.QVBoxLayout()
        self.verticalLayout_7.setObjectName("verticalLayout_7")
        self.chk_is_screw_pullout = QtWidgets.QCheckBox(self.groupBox_8)
        self.chk_is_screw_pullout.setObjectName("chk_is_screw_pullout")
        self.verticalLayout_7.addWidget(self.chk_is_screw_pullout)
        self.chk_screws_number = QtWidgets.QCheckBox(self.groupBox_8)
        self.chk_screws_number.setObjectName("chk_screws_number")
        self.verticalLayout_7.addWidget(self.chk_screws_number)
        self.horizontalLayout_9.addLayout(self.verticalLayout_7)
        self.verticalLayout_6.addWidget(self.groupBox_8)
        self.horizontalLayout_4.addLayout(self.verticalLayout_6)
        self.verticalLayout_10 = QtWidgets.QVBoxLayout()
        self.verticalLayout_10.setObjectName("verticalLayout_10")
        self.groupBox_9 = QtWidgets.QGroupBox(Dialog)
        self.groupBox_9.setObjectName("groupBox_9")
        self.horizontalLayout_11 = QtWidgets.QHBoxLayout(self.groupBox_9)
        self.horizontalLayout_11.setObjectName("horizontalLayout_11")
        self.gridLayout = QtWidgets.QGridLayout()
        self.gridLayout.setObjectName("gridLayout")
        self.edt_frame_width = QtWidgets.QLineEdit(self.groupBox_9)
        self.edt_frame_width.setObjectName("edt_frame_width")
        self.gridLayout.addWidget(self.edt_frame_width, 0, 2, 1, 1)
        self.lab_hydr_head = QtWidgets.QLabel(self.groupBox_9)
        self.lab_hydr_head.setEnabled(False)
        self.lab_hydr_head.setObjectName("lab_hydr_head")
        self.gridLayout.addWidget(self.lab_hydr_head, 3, 0, 1, 1)
        self.label_6 = QtWidgets.QLabel(self.groupBox_9)
        self.label_6.setObjectName("label_6")
        self.gridLayout.addWidget(self.label_6, 4, 0, 1, 1)
        self.label_2 = QtWidgets.QLabel(self.groupBox_9)
        self.label_2.setObjectName("label_2")
        self.gridLayout.addWidget(self.label_2, 0, 0, 1, 1)
        self.edt_frame_height = QtWidgets.QLineEdit(self.groupBox_9)
        self.edt_frame_height.setObjectName("edt_frame_height")
        self.gridLayout.addWidget(self.edt_frame_height, 1, 2, 1, 1)
        self.edt_gate_height = QtWidgets.QLineEdit(self.groupBox_9)
        self.edt_gate_height.setObjectName("edt_gate_height")
        self.gridLayout.addWidget(self.edt_gate_height, 2, 2, 1, 1)
        self.label_3 = QtWidgets.QLabel(self.groupBox_9)
        self.label_3.setObjectName("label_3")
        self.gridLayout.addWidget(self.label_3, 1, 0, 1, 1)
        self.label_4 = QtWidgets.QLabel(self.groupBox_9)
        self.label_4.setObjectName("label_4")
        self.gridLayout.addWidget(self.label_4, 2, 0, 1, 1)
        self.edt_hydr_head = QtWidgets.QLineEdit(self.groupBox_9)
        self.edt_hydr_head.setEnabled(False)
        self.edt_hydr_head.setObjectName("edt_hydr_head")
        self.gridLayout.addWidget(self.edt_hydr_head, 3, 2, 1, 1)
        self.edt_density = QtWidgets.QLineEdit(self.groupBox_9)
        self.edt_density.setObjectName("edt_density")
        self.gridLayout.addWidget(self.edt_density, 4, 2, 1, 1)
        spacerItem1 = QtWidgets.QSpacerItem(0, 0, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout.addItem(spacerItem1, 5, 1, 1, 1)
        self.horizontalLayout_11.addLayout(self.gridLayout)
        self.verticalLayout_10.addWidget(self.groupBox_9)
        self.grp_rack = QtWidgets.QGroupBox(Dialog)
        self.grp_rack.setCheckable(True)
        self.grp_rack.setChecked(False)
        self.grp_rack.setObjectName("grp_rack")
        self.horizontalLayout_14 = QtWidgets.QHBoxLayout(self.grp_rack)
        self.horizontalLayout_14.setObjectName("horizontalLayout_14")
        self.horizontalLayout_15 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_15.setObjectName("horizontalLayout_15")
        self.label_9 = QtWidgets.QLabel(self.grp_rack)
        self.label_9.setWordWrap(False)
        self.label_9.setObjectName("label_9")
        self.horizontalLayout_15.addWidget(self.label_9)
        spacerItem2 = QtWidgets.QSpacerItem(0, 0, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_15.addItem(spacerItem2)
        self.edt_rack_dist = QtWidgets.QLineEdit(self.grp_rack)
        self.edt_rack_dist.setObjectName("edt_rack_dist")
        self.horizontalLayout_15.addWidget(self.edt_rack_dist)
        self.horizontalLayout_14.addLayout(self.horizontalLayout_15)
        self.verticalLayout_10.addWidget(self.grp_rack)
        self.grp_flow = QtWidgets.QGroupBox(Dialog)
        self.grp_flow.setEnabled(False)
        self.grp_flow.setObjectName("grp_flow")
        self.horizontalLayout_17 = QtWidgets.QHBoxLayout(self.grp_flow)
        self.horizontalLayout_17.setObjectName("horizontalLayout_17")
        self.verticalLayout_5 = QtWidgets.QVBoxLayout()
        self.verticalLayout_5.setObjectName("verticalLayout_5")
        self.horizontalLayout_5 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_5.setObjectName("horizontalLayout_5")
        self.label_10 = QtWidgets.QLabel(self.grp_flow)
        self.label_10.setWordWrap(False)
        self.label_10.setObjectName("label_10")
        self.horizontalLayout_5.addWidget(self.label_10)
        self.edt_flow_dist = QtWidgets.QLineEdit(self.grp_flow)
        self.edt_flow_dist.setObjectName("edt_flow_dist")
        self.horizontalLayout_5.addWidget(self.edt_flow_dist)
        self.verticalLayout_5.addLayout(self.horizontalLayout_5)
        spacerItem3 = QtWidgets.QSpacerItem(0, 0, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.verticalLayout_5.addItem(spacerItem3)
        self.chk_fixed_gate = QtWidgets.QCheckBox(self.grp_flow)
        self.chk_fixed_gate.setObjectName("chk_fixed_gate")
        self.verticalLayout_5.addWidget(self.chk_fixed_gate)
        self.horizontalLayout_17.addLayout(self.verticalLayout_5)
        self.verticalLayout_10.addWidget(self.grp_flow)
        self.groupBox_4 = QtWidgets.QGroupBox(Dialog)
        self.groupBox_4.setObjectName("groupBox_4")
        self.horizontalLayout_12 = QtWidgets.QHBoxLayout(self.groupBox_4)
        self.horizontalLayout_12.setObjectName("horizontalLayout_12")
        self.gridLayout_2 = QtWidgets.QGridLayout()
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.edt_screw = QtWidgets.QLineEdit(self.groupBox_4)
        self.edt_screw.setObjectName("edt_screw")
        self.gridLayout_2.addWidget(self.edt_screw, 2, 1, 1, 1)
        self.label_7 = QtWidgets.QLabel(self.groupBox_4)
        self.label_7.setObjectName("label_7")
        self.gridLayout_2.addWidget(self.label_7, 2, 0, 1, 1)
        self.label_5 = QtWidgets.QLabel(self.groupBox_4)
        self.label_5.setObjectName("label_5")
        self.gridLayout_2.addWidget(self.label_5, 1, 0, 1, 1)
        self.edt_way = QtWidgets.QLineEdit(self.groupBox_4)
        self.edt_way.setObjectName("edt_way")
        self.gridLayout_2.addWidget(self.edt_way, 4, 1, 1, 1)
        self.groupBox_5 = QtWidgets.QGroupBox(self.groupBox_4)
        self.groupBox_5.setStyleSheet("border:0;")
        self.groupBox_5.setTitle("")
        self.groupBox_5.setObjectName("groupBox_5")
        self.horizontalLayout_19 = QtWidgets.QHBoxLayout(self.groupBox_5)
        self.horizontalLayout_19.setContentsMargins(2, 2, 2, 2)
        self.horizontalLayout_19.setObjectName("horizontalLayout_19")
        self.horizontalLayout_18 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_18.setObjectName("horizontalLayout_18")
        self.rad_wedge_pairs_auto = QtWidgets.QRadioButton(self.groupBox_5)
        self.rad_wedge_pairs_auto.setChecked(True)
        self.rad_wedge_pairs_auto.setObjectName("rad_wedge_pairs_auto")
        self.horizontalLayout_18.addWidget(self.rad_wedge_pairs_auto)
        self.rad_wedge_pairs_three = QtWidgets.QRadioButton(self.groupBox_5)
        self.rad_wedge_pairs_three.setObjectName("rad_wedge_pairs_three")
        self.horizontalLayout_18.addWidget(self.rad_wedge_pairs_three)
        self.horizontalLayout_19.addLayout(self.horizontalLayout_18)
        self.gridLayout_2.addWidget(self.groupBox_5, 6, 1, 1, 1)
        self.label = QtWidgets.QLabel(self.groupBox_4)
        self.label.setObjectName("label")
        self.gridLayout_2.addWidget(self.label, 0, 0, 1, 1)
        self.label_11 = QtWidgets.QLabel(self.groupBox_4)
        self.label_11.setObjectName("label_11")
        self.gridLayout_2.addWidget(self.label_11, 5, 0, 1, 1)
        self.groupBox_3 = QtWidgets.QGroupBox(self.groupBox_4)
        self.groupBox_3.setStyleSheet("border:0;")
        self.groupBox_3.setTitle("")
        self.groupBox_3.setObjectName("groupBox_3")
        self.horizontalLayout_6 = QtWidgets.QHBoxLayout(self.groupBox_3)
        self.horizontalLayout_6.setContentsMargins(2, 2, 2, 2)
        self.horizontalLayout_6.setObjectName("horizontalLayout_6")
        self.horizontalLayout_13 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_13.setObjectName("horizontalLayout_13")
        self.rad_have_nodes_in_frame_auto = QtWidgets.QRadioButton(self.groupBox_3)
        self.rad_have_nodes_in_frame_auto.setChecked(True)
        self.rad_have_nodes_in_frame_auto.setObjectName("rad_have_nodes_in_frame_auto")
        self.horizontalLayout_13.addWidget(self.rad_have_nodes_in_frame_auto)
        self.rad_have_nodes_in_frame_none = QtWidgets.QRadioButton(self.groupBox_3)
        self.rad_have_nodes_in_frame_none.setObjectName("rad_have_nodes_in_frame_none")
        self.horizontalLayout_13.addWidget(self.rad_have_nodes_in_frame_none)
        self.horizontalLayout_6.addLayout(self.horizontalLayout_13)
        self.gridLayout_2.addWidget(self.groupBox_3, 5, 1, 1, 1)
        self.label_8 = QtWidgets.QLabel(self.groupBox_4)
        self.label_8.setObjectName("label_8")
        self.gridLayout_2.addWidget(self.label_8, 4, 0, 1, 1)
        self.cmb_auma = QtWidgets.QComboBox(self.groupBox_4)
        self.cmb_auma.setObjectName("cmb_auma")
        self.cmb_auma.addItem("")
        self.gridLayout_2.addWidget(self.cmb_auma, 0, 1, 1, 1)
        self.cmb_reducer = QtWidgets.QComboBox(self.groupBox_4)
        self.cmb_reducer.setObjectName("cmb_reducer")
        self.cmb_reducer.addItem("")
        self.gridLayout_2.addWidget(self.cmb_reducer, 1, 1, 1, 1)
        self.label_12 = QtWidgets.QLabel(self.groupBox_4)
        self.label_12.setObjectName("label_12")
        self.gridLayout_2.addWidget(self.label_12, 6, 0, 1, 1)
        self.edt_pitch = QtWidgets.QLineEdit(self.groupBox_4)
        self.edt_pitch.setObjectName("edt_pitch")
        self.gridLayout_2.addWidget(self.edt_pitch, 3, 1, 1, 1)
        self.label_13 = QtWidgets.QLabel(self.groupBox_4)
        self.label_13.setObjectName("label_13")
        self.gridLayout_2.addWidget(self.label_13, 3, 0, 1, 1)
        self.horizontalLayout_12.addLayout(self.gridLayout_2)
        self.verticalLayout_10.addWidget(self.groupBox_4)
        self.horizontalLayout_4.addLayout(self.verticalLayout_10)
        self.verticalLayout_8 = QtWidgets.QVBoxLayout()
        self.verticalLayout_8.setObjectName("verticalLayout_8")
        self.groupBox_10 = QtWidgets.QGroupBox(Dialog)
        self.groupBox_10.setObjectName("groupBox_10")
        self.horizontalLayout_10 = QtWidgets.QHBoxLayout(self.groupBox_10)
        self.horizontalLayout_10.setObjectName("horizontalLayout_10")
        self.txt_result = QtWidgets.QPlainTextEdit(self.groupBox_10)
        self.txt_result.setMinimumSize(QtCore.QSize(400, 0))
        self.txt_result.setReadOnly(True)
        self.txt_result.setObjectName("txt_result")
        self.horizontalLayout_10.addWidget(self.txt_result)
        self.verticalLayout_8.addWidget(self.groupBox_10)
        self.horizontalLayout_3 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_3.setObjectName("horizontalLayout_3")
        self.groupBox1 = QtWidgets.QGroupBox(Dialog)
        self.groupBox1.setStyleSheet("border:0;")
        self.groupBox1.setObjectName("groupBox1")
        self.horizontalLayout_7 = QtWidgets.QHBoxLayout(self.groupBox1)
        self.horizontalLayout_7.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout_7.setObjectName("horizontalLayout_7")
        self.rad_lang_ru = QtWidgets.QRadioButton(self.groupBox1)
        self.rad_lang_ru.setChecked(True)
        self.rad_lang_ru.setObjectName("rad_lang_ru")
        self.horizontalLayout_7.addWidget(self.rad_lang_ru)
        self.rad_lang_en = QtWidgets.QRadioButton(self.groupBox1)
        self.rad_lang_en.setObjectName("rad_lang_en")
        self.horizontalLayout_7.addWidget(self.rad_lang_en)
        self.horizontalLayout_3.addWidget(self.groupBox1)
        spacerItem4 = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_3.addItem(spacerItem4)
        self.btn_run = QtWidgets.QPushButton(Dialog)
        self.btn_run.setObjectName("btn_run")
        self.horizontalLayout_3.addWidget(self.btn_run)
        self.verticalLayout_8.addLayout(self.horizontalLayout_3)
        self.horizontalLayout_4.addLayout(self.verticalLayout_8)
        self.formLayout.setLayout(0, QtWidgets.QFormLayout.LabelRole, self.horizontalLayout_4)

        self.retranslateUi(Dialog)
        QtCore.QMetaObject.connectSlotsByName(Dialog)
        Dialog.setTabOrder(self.rad_kind_surf, self.rad_kind_deep)
        Dialog.setTabOrder(self.rad_kind_deep, self.rad_kind_flow)
        Dialog.setTabOrder(self.rad_kind_flow, self.rad_drive_electric)
        Dialog.setTabOrder(self.rad_drive_electric, self.rad_drive_reducer)
        Dialog.setTabOrder(self.rad_drive_reducer, self.rad_drive_manual)
        Dialog.setTabOrder(self.rad_drive_manual, self.grp_motor_control)
        Dialog.setTabOrder(self.grp_motor_control, self.rad_simple_control)
        Dialog.setTabOrder(self.rad_simple_control, self.rad_extended_control)
        Dialog.setTabOrder(self.rad_extended_control, self.cmb_install)
        Dialog.setTabOrder(self.cmb_install, self.chk_closed_frame)
        Dialog.setTabOrder(self.chk_closed_frame, self.chk_is_screw_pullout)
        Dialog.setTabOrder(self.chk_is_screw_pullout, self.chk_screws_number)
        Dialog.setTabOrder(self.chk_screws_number, self.edt_frame_width)
        Dialog.setTabOrder(self.edt_frame_width, self.edt_frame_height)
        Dialog.setTabOrder(self.edt_frame_height, self.edt_gate_height)
        Dialog.setTabOrder(self.edt_gate_height, self.edt_hydr_head)
        Dialog.setTabOrder(self.edt_hydr_head, self.edt_density)
        Dialog.setTabOrder(self.edt_density, self.grp_rack)
        Dialog.setTabOrder(self.grp_rack, self.edt_rack_dist)
        Dialog.setTabOrder(self.edt_rack_dist, self.edt_flow_dist)
        Dialog.setTabOrder(self.edt_flow_dist, self.chk_fixed_gate)
        Dialog.setTabOrder(self.chk_fixed_gate, self.cmb_auma)
        Dialog.setTabOrder(self.cmb_auma, self.cmb_reducer)
        Dialog.setTabOrder(self.cmb_reducer, self.edt_screw)
        Dialog.setTabOrder(self.edt_screw, self.edt_pitch)
        Dialog.setTabOrder(self.edt_pitch, self.edt_way)
        Dialog.setTabOrder(self.edt_way, self.rad_have_nodes_in_frame_auto)
        Dialog.setTabOrder(self.rad_have_nodes_in_frame_auto, self.rad_have_nodes_in_frame_none)
        Dialog.setTabOrder(self.rad_have_nodes_in_frame_none, self.rad_wedge_pairs_auto)
        Dialog.setTabOrder(self.rad_wedge_pairs_auto, self.rad_wedge_pairs_three)
        Dialog.setTabOrder(self.rad_wedge_pairs_three, self.txt_result)
        Dialog.setTabOrder(self.txt_result, self.rad_lang_ru)
        Dialog.setTabOrder(self.rad_lang_ru, self.rad_lang_en)
        Dialog.setTabOrder(self.rad_lang_en, self.btn_run)

    def retranslateUi(self, Dialog):
        _translate = QtCore.QCoreApplication.translate
        Dialog.setWindowTitle(_translate("Dialog", "Расчет щитовых затворов"))
        self.groupBox.setTitle(_translate("Dialog", "Тип затвора"))
        self.rad_kind_surf.setText(_translate("Dialog", "Поверхностный"))
        self.rad_kind_deep.setText(_translate("Dialog", "Глубинный"))
        self.rad_kind_flow.setText(_translate("Dialog", "Переливной"))
        self.groupBox_2.setTitle(_translate("Dialog", "Управление"))
        self.rad_drive_electric.setText(_translate("Dialog", "Электропривод"))
        self.rad_drive_reducer.setText(_translate("Dialog", "Ручной редуктор"))
        self.rad_drive_manual.setText(_translate("Dialog", "Маховик"))
        self.grp_motor_control.setTitle(_translate("Dialog", "Блок управления"))
        self.rad_simple_control.setToolTip(_translate("Dialog", "Управляет командами ОТКРЫТЬ, СТОП, ЗАКРЫТЬ, отображает ошибки, возникающие во время работы, сигнализирует о достижении конечного положения."))
        self.rad_simple_control.setText(_translate("Dialog", "AUMA MATIC (AM)"))
        self.rad_extended_control.setToolTip(_translate("Dialog", "Выполняет все функции AUMA MATIC, а также передает данные о состоянии привода: время работы, температура, вибрация."))
        self.rad_extended_control.setText(_translate("Dialog", "AUMATIC (АС)"))
        self.groupBox_12.setTitle(_translate("Dialog", "Установка"))
        self.cmb_install.setItemText(0, _translate("Dialog", "Штрабная"))
        self.cmb_install.setItemText(1, _translate("Dialog", "Канальная"))
        self.cmb_install.setItemText(2, _translate("Dialog", "Настенная"))
        self.cmb_install.setItemText(3, _translate("Dialog", "На фланце"))
        self.cmb_install.setItemText(4, _translate("Dialog", "На двух фланцах"))
        self.chk_closed_frame.setText(_translate("Dialog", "С закрытой рамой"))
        self.groupBox_8.setTitle(_translate("Dialog", "Опционально"))
        self.chk_is_screw_pullout.setText(_translate("Dialog", "С выдвижным винтом"))
        self.chk_screws_number.setText(_translate("Dialog", "С двумя винтами"))
        self.groupBox_9.setTitle(_translate("Dialog", "Основные параметры"))
        self.lab_hydr_head.setText(_translate("Dialog", "Гидростатический напор (м):"))
        self.label_6.setText(_translate("Dialog", "Плотность жидкости (кг/м3):"))
        self.label_2.setText(_translate("Dialog", "Ширина рамы (м):"))
        self.label_3.setText(_translate("Dialog", "Высота рамы (м):"))
        self.label_4.setText(_translate("Dialog", "Высота щита (м):"))
        self.edt_density.setText(_translate("Dialog", "1000"))
        self.grp_rack.setTitle(_translate("Dialog", "С выносной колонкой"))
        self.label_9.setText(_translate("Dialog", "От верха рамы до земли (м):"))
        self.grp_flow.setTitle(_translate("Dialog", "Для переливных затворов"))
        self.label_10.setText(_translate("Dialog", "От верха рамы до верха щита (м):"))
        self.chk_fixed_gate.setText(_translate("Dialog", "С неподвижным щитом"))
        self.groupBox_4.setTitle(_translate("Dialog", "Переопределить выбор программы"))
        self.edt_screw.setPlaceholderText(_translate("Dialog", "Авто"))
        self.label_7.setText(_translate("Dialog", "Диаметр винта (мм):"))
        self.label_5.setText(_translate("Dialog", "Ручной редуктор:"))
        self.edt_way.setPlaceholderText(_translate("Dialog", "Авто"))
        self.rad_wedge_pairs_auto.setText(_translate("Dialog", "Авто"))
        self.rad_wedge_pairs_three.setText(_translate("Dialog", "Три пары"))
        self.label.setText(_translate("Dialog", "Мотор-редуктор:"))
        self.label_11.setText(_translate("Dialog", "Промеж. опора в раме:"))
        self.rad_have_nodes_in_frame_auto.setText(_translate("Dialog", "Авто"))
        self.rad_have_nodes_in_frame_none.setText(_translate("Dialog", "Без опор"))
        self.label_8.setText(_translate("Dialog", "Ход винта (м):"))
        self.cmb_auma.setCurrentText(_translate("Dialog", "Авто"))
        self.cmb_auma.setItemText(0, _translate("Dialog", "Авто"))
        self.cmb_reducer.setItemText(0, _translate("Dialog", "Авто"))
        self.label_12.setText(_translate("Dialog", "Кол-во пар клиньев:"))
        self.edt_pitch.setPlaceholderText(_translate("Dialog", "Указывать с диаметром"))
        self.label_13.setText(_translate("Dialog", "Шаг винта (мм):"))
        self.groupBox_10.setTitle(_translate("Dialog", "Результаты расчета"))
        self.rad_lang_ru.setText(_translate("Dialog", "ru"))
        self.rad_lang_en.setText(_translate("Dialog", "en"))
        self.btn_run.setText(_translate("Dialog", "Выполнить"))
