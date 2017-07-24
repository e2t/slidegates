# coding: utf-8
import sys
import os
from cx_Freeze import setup, Executable
from version import __version__

sys.path.append('..')
build_exe_options = {
    'packages': ['dry.core', 'dry.qt'],
    'include_files': ['lang', '../dry/lang'],
}

DESCRIPTION = 'Расчет щитовых затворов'

base = None
if sys.platform == 'win32':
    base = 'Win32GUI'

NAME = os.path.basename(os.path.abspath(os.curdir))

setup(name=NAME.title(),
      version=__version__,
      description = DESCRIPTION,
      options={'build_exe': build_exe_options},
      executables=[Executable(
          'main.py', base=base, icon='favicon.ico',
          targetName='{0}.exe'.format(NAME),
          shortcutName=DESCRIPTION,
          shortcutDir='DesktopFolder')])
