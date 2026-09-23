@echo off
REM =====================
REM OFFENSIVE-CRAB-V1 - Windows Installation Script
REM Author: Ian Carter Kulani, MSc
REM Version: 1.0.0
REM =====================

setlocal EnableDelayedExpansion

title OFFENSIVE-CRAB-V1 Installer

REM Configuration
set TOOL_NAME=OFFENSIVE-CRAB-V1
set TOOL_VERSION=1.0.0
set INSTALL_DIR=%ProgramFiles%\OffensiveCrabV1
set VENV_DIR=%INSTALL_DIR%\venv
set CONFIG_DIR=%USERPROFILE%\.offensive_crab_v1
set LOG_FILE=%TEMP%\offensive_crab_install.log

REM Colors (approximate)
set RED=[91m
set GREEN=[92m
set YELLOW=[93m
set BLUE=[94m
set NC=[0m

REM Print banner
:banner
cls
echo.
echo ==============================================================================
echo        OFFENSIVE-CRAB-V1 - Installation Script
echo        Ultimate Cybersecurity Command & Control Platform
echo ==============================================================================
echo   Author: Ian Carter Kulani, MSc
echo   Version: 1.0.0
echo   License: MIT
echo ==============================================================================
echo.

REM Check admin
:check_admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Administrator privileges required for full installation.
    echo [*] Attempting to elevate...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
echo [+] Running with administrator privileges

REM Check Python
:check_python
echo.
echo [*] Checking Python installation...
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Python not found. Please install Python 3.7+ from https://python.org
    echo [*] Or install from Microsoft Store: python3
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [+] Found Python %PYTHON_VERSION%

REM Check pip
pip --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] pip not found. Installing...
    python -m ensurepip --default-pip
)

REM Create installation directory
:setup_dir
echo.
echo [*] Creating installation directory: %INSTALL_DIR%
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)
if not exist "%CONFIG_DIR%" (
    mkdir "%CONFIG_DIR%"
)
if not exist "%CONFIG_DIR%\payloads" (
    mkdir "%CONFIG_DIR%\payloads"
)
if not exist "%CONFIG_DIR%\reports" (
    mkdir "%CONFIG_DIR%\reports"
)
if not exist "%CONFIG_DIR%\scans" (
    mkdir "%CONFIG_DIR%\scans"
)
echo [+] Directories created

REM Copy files
:copy_files
echo.
echo [*] Copying files...
if exist "offensive_crab_v1.py" (
    copy /Y "offensive_crab_v1.py" "%INSTALL_DIR%\" >nul
) else (
    echo [!] offensive_crab_v1.py not found!
    pause
    exit /b 1
)

for %%f in (requirements.txt requirements-check.py healthcheck.py setup.py README.md LICENSE) do (
    if exist "%%f" copy /Y "%%f" "%INSTALL_DIR%\" >nul
)
echo [+] Files copied

REM Create virtual environment
:create_venv
echo.
echo [*] Creating virtual environment...
python -m venv "%VENV_DIR%"
call "%VENV_DIR%\Scripts\activate.bat"

REM Upgrade pip
python -m pip install --upgrade pip setuptools wheel

echo [+] Virtual environment created

REM Install dependencies
:install_deps
echo.
echo [*] Installing Python dependencies...
if exist "%INSTALL_DIR%\requirements.txt" (
    pip install -r "%INSTALL_DIR%\requirements.txt"
    if !errorLevel! neq 0 (
        echo [!] Some packages failed to install. Trying individually...
        for /f "usebackq tokens=*" %%p in ("%INSTALL_DIR%\requirements.txt") do (
            echo %%p | findstr /b "#" >nul
            if !errorLevel! neq 0 (
                echo %%p | findstr /b "-" >nul
                if !errorLevel! neq 0 (
                    pip install %%p 2>nul
                )
            )
        )
    )
)

REM Install the package
if exist "%INSTALL_DIR%\setup.py" (
    pip install -e "%INSTALL_DIR%"
)

echo [+] Dependencies installed

REM Create launcher
:create_launcher
echo.
echo [*] Creating launcher...

REM Create batch launcher
(
echo @echo off
echo set OFFENSIVE_CRAB_HOME=%INSTALL_DIR%
echo call "%VENV_DIR%\Scripts\activate.bat"
echo cd /d "%INSTALL_DIR%"
echo python offensive_crab_v1.py %%*
) > "%INSTALL_DIR%\offensive-crab.bat"

REM Create check launcher
(
echo @echo off
echo call "%VENV_DIR%\Scripts\activate.bat"
echo python "%INSTALL_DIR%\requirements-check.py" %%*
) > "%INSTALL_DIR%\offensive-crab-check.bat"

REM Add to PATH
setx PATH "%PATH%;%INSTALL_DIR%" /M >nul 2>&1

echo [+] Launchers created

REM Create config
:create_config
echo.
echo [*] Creating default configuration...
if not exist "%CONFIG_DIR%\config.json" (
    (
    echo {
    echo     "version": "1.0.0",
    echo     "auto_start": false,
    echo     "auto_block_enabled": false,
    echo     "auto_block_threshold": 5,
    echo     "scan_timeout": 30,
    echo     "report_format": "pdf",
    echo     "generate_graphics": true
    echo }
    ) > "%CONFIG_DIR%\config.json"
    echo [+] Configuration created
) else (
    echo [+] Configuration already exists
)

REM Create desktop shortcut
:create_shortcut
echo.
echo [*] Creating desktop shortcut...
powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%USERPROFILE%\Desktop\OFFENSIVE-CRAB-V1.lnk'); $SC.TargetPath = '%INSTALL_DIR%\offensive-crab.bat'; $SC.WorkingDirectory = '%INSTALL_DIR%'; $SC.Description = 'Ultimate Cybersecurity Command & Control Platform'; $SC.Save()"
echo [+] Desktop shortcut created

REM Verify
:verify
echo.
echo [*] Verifying installation...
call "%VENV_DIR%\Scripts\activate.bat"
python -c "import sys; sys.path.insert(0, '%INSTALL_DIR%'); import offensive_crab_v1; print('OK')" >nul 2>&1
if !errorLevel! equ 0 (
    echo [+] Main module imports successfully
) else (
    echo [!] Import test failed - some dependencies may be missing
)

REM Done
:done
echo.
echo ==============================================================================
echo        OFFENSIVE-CRAB-V1 Installation Complete!
echo ==============================================================================
echo.
echo   Run the tool:    offensive-crab.bat
echo   Or from PATH:    offensive-crab
echo   Check deps:      offensive-crab-check
echo.
echo   Install dir:     %INSTALL_DIR%
echo   Config dir:      %CONFIG_DIR%
echo.
echo   [i] First run will prompt for configuration
echo   [i] Run as Administrator for full functionality
echo.
echo   [!] FOR AUTHORIZED SECURITY TESTING ONLY
echo ==============================================================================
echo.

pause
endlocal
