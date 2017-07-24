#!/usr/bin/env python3
from main import MainWindow, main


class TestWindow(MainWindow):
    def __init__(self):
        super(TestWindow, self).__init__()
        if __debug__:
            # self.rad_kind_surf.setChecked(True)
            self.rad_kind_deep.setChecked(True)
            # self.rad_kind_flow.setChecked(True)

            self.edt_frame_width.setText('0.75')
            self.edt_frame_height.setText('1.7')
            self.edt_gate_height.setText('0.75')
            self.edt_hydr_head.setText('4.5')

            # self.rad_drive_electric.setChecked(True)
            # self.rad_drive_reducer.setChecked(True)
            self.rad_drive_manual.setChecked(True)

            self.cmb_install.setCurrentIndex(2)

            self.grp_rack.setChecked(True)
            self.edt_rack_dist.setText('2.9')

            # self.edt_flow_dist.setText('0.5')
            # self.chk_fixed_gate.setChecked(True)

            # self.chk_is_screw_pullout.setChecked(True)

            # self.chk_screws_number.setChecked(True)

            self._run()


if __name__ == '__main__':
    main(TestWindow)
