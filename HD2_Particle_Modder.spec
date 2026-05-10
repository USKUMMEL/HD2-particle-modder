# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['particle_modder.py'],
    pathex=[],
    binaries=[],
    datas=[('assets', 'assets')],
    hiddenimports=[
        'matplotlib',
        'matplotlib.pyplot',
        'matplotlib.backends.backend_qtagg',
        'numpy',
        'cycler',
        'scipy',
        'scipy.spatial.transform',
        'PySide6.QtCharts',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='HD2_Particle_Modder',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=['assets\\icon.PNG'],
)
