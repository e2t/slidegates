# coding: utf-8
import sys
from cx_Freeze import setup, Executable
sys.path.append(f'{sys.path[0]}/..')
import manifest


BUILD_EXE_OPTIONS = {
    'packages': ['dry.core', 'dry.qt'],
    'include_files': [
        'lang', '../dry/lang',
        r'c:\Program Files (x86)\Python37-32\Lib\site-packages\PyQt5\Qt\plugins\platforms']}

BASE = 'Win32GUI'

SHORTCUT_TABLE = [
    ('DesktopShortcut',                  # Shortcut
     'DesktopFolder',                    # Directory_
     manifest.DESCRIPTION,               # Name
     'TARGETDIR',                        # Component_
     f'[TARGETDIR]{manifest.NAME}.exe',  # Target
     None,                               # Arguments
     None,                               # Description
     None,                               # Hotkey
     None,                               # Icon
     None,                               # IconIndex
     None,                               # ShowCmd
     'TARGETDIR'                         # WkDir
     )
]

MSI_DATA = {'Shortcut': SHORTCUT_TABLE}

BDIST_MSI_OPTIONS = {'data': MSI_DATA}

setup(name=manifest.NAME.title(),
      version=manifest.VERSION,
      description=manifest.DESCRIPTION,
      options={'build_exe': BUILD_EXE_OPTIONS,
               'bdist_msi': BDIST_MSI_OPTIONS},
      executables=[Executable(
          'main.py', base=BASE,
          targetName=f'{manifest.NAME}.exe',
          icon='favicon.ico')])
