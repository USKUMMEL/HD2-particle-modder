@echo off
setlocal EnableExtensions EnableDelayedExpansion

cd /d "%~dp0"

echo ========================================
echo Building HD2 Particle Modder...
echo ========================================
echo.

set "PYTHON_CMD="
set "BASE_PYTHON_CMD="

if exist ".venv\Scripts\python.exe" (
    ".venv\Scripts\python.exe" -c "import sys" >nul 2>nul
    if !ERRORLEVEL! EQU 0 set "PYTHON_CMD="%CD%\.venv\Scripts\python.exe""
)

if not defined PYTHON_CMD if exist ".backup\.venv\Scripts\python.exe" (
    ".backup\.venv\Scripts\python.exe" -c "import sys" >nul 2>nul
    if !ERRORLEVEL! EQU 0 set "PYTHON_CMD="%CD%\.backup\.venv\Scripts\python.exe""
)

if not defined PYTHON_CMD (
    where py >nul 2>nul
    if !ERRORLEVEL! EQU 0 (
        py -3 -c "import sys" >nul 2>nul
        if !ERRORLEVEL! EQU 0 set "BASE_PYTHON_CMD=py -3"
    )
)

if not defined BASE_PYTHON_CMD (
    where python >nul 2>nul
    if !ERRORLEVEL! EQU 0 (
        python -c "import sys" >nul 2>nul
        if !ERRORLEVEL! EQU 0 set "BASE_PYTHON_CMD=python"
    )
)

if not defined PYTHON_CMD (
    if not defined BASE_PYTHON_CMD (
        echo Could not find Python. Install Python 3.14 or add Python to PATH.
        goto :fail
    )

    echo Creating local virtual environment...
    %BASE_PYTHON_CMD% -m venv ".venv"
    if !ERRORLEVEL! NEQ 0 goto :fail
    set "PYTHON_CMD="%CD%\.venv\Scripts\python.exe""
)

%PYTHON_CMD% -c "import PyInstaller, PySide6, scipy, matplotlib, numpy" >nul 2>nul
if !ERRORLEVEL! NEQ 0 (
    echo Installing build dependencies...
    %PYTHON_CMD% -m pip install --upgrade pip
    if !ERRORLEVEL! NEQ 0 goto :fail
    %PYTHON_CMD% -m pip install -r requirements.txt
    if !ERRORLEVEL! NEQ 0 goto :fail
)

if not exist "HD2_Particle_Modder.spec" (
    echo Missing HD2_Particle_Modder.spec.
    goto :fail
)

if exist "dist\HD2_Particle_Modder.exe" (
    echo Removing old exe...
    del /F "dist\HD2_Particle_Modder.exe"
)

echo Building executable...
%PYTHON_CMD% -m PyInstaller HD2_Particle_Modder.spec --noconfirm --clean

if !ERRORLEVEL! EQU 0 (
    echo.
    echo ========================================
    echo Build SUCCESS!
    echo ========================================
    echo.
    echo File location: dist\HD2_Particle_Modder.exe
    if exist "dist\HD2_Particle_Modder.exe" (
        for %%F in ("dist\HD2_Particle_Modder.exe") do (
            set /a sizeMB=%%~zF/1024/1024
        )
        echo File size: !sizeMB! MB
    )
    echo.
    pause
    exit /b 0
)

:fail
echo.
echo ========================================
echo Build FAILED!
echo ========================================
echo.
echo Check the error messages above.
echo.
pause
exit /b 1
