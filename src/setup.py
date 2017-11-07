# coding: utf-8
import sys
from cx_Freeze import setup, Executable
import manifest
sys.path.append('..')

BUILD_EXE_OPTIONS = {
    'packages': ['dry.core', 'dry.qt'],
    'include_files': ['lang', '../dry/lang'],
}
if sys.platform == 'win32':
    BASE = 'Win32GUI'
else:
    BASE = None

setup(name=manifest.NAME.title(),
      version=manifest.VERSION,
      description=manifest.DESCRIPTION,
      options={'build_exe': BUILD_EXE_OPTIONS},
      executables=[Executable(
          'main.py', base=BASE, icon='favicon.ico',
          targetName='{0}.exe'.format(manifest.NAME),
          shortcutName=manifest.DESCRIPTION,
          shortcutDir='DesktopFolder')])
