@echo off
REM =====================
REM OFFENSIVE-CRAB-V1 - Windows Uninstall Script
REM Author: Ian Carter Kulani, MSc
REM Version: 1.0.0
REM =====================

setlocal EnableDelayedExpansion

title OFFENSIVE-CRAB-V1 Uninstaller

set INSTALL_DIR=%ProgramFiles%\OffensiveCrabV1
set CONFIG_DIR=%USERPROFILE%\.offensive_crab_v1

echo.
echo ==============================================================================
echo        OFFENSIVE-CRAB-V1 - Uninstaller
echo ==============================================================================
echo.

set /p CONFIRM="Are you sure you want to uninstall? [y/N]: "
if /i not "%CONFIRM%"=="y" (
    echo Uninstall cancelled.
    pause
    exit /b 0
)

echo.
echo [*] Removing files...

REM Check admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Administrator privileges required.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

REM Remove installation directory
if exist "%INSTALL_DIR%" (
    rmdir /S /Q "%INSTALL_DIR%"
    echo [+] Removed %INSTALL_DIR%
)

REM Remove from PATH
powershell -Command "$path = [Environment]::GetEnvironmentVariable('Path', 'Machine'); $newPath = ($path.Split(';') ^| Where-Object { $_ -ne '%INSTALL_DIR%' }) -join ';'; [Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine')" 2>nul
echo [+] Removed from PATH

REM Remove desktop shortcut
if exist "%USERPROFILE%\Desktop\OFFENSIVE-CRAB-V1.lnk" (
    del /Q "%USERPROFILE%\Desktop\OFFENSIVE-CRAB-V1.lnk"
    echo [+] Removed desktop shortcut
)

REM Ask about config
set /p REMOVE_CONFIG="Remove configuration and data? [y/N]: "
if /i "%REMOVE_CONFIG%"=="y" (
    if exist "%CONFIG_DIR%" (
        REM Backup first
        set BACKUP=%USERPROFILE%\offensive_crab_backup_%date:~-4%%date:~4,2%%date:~7,2%.zip
        powershell -Command "Compress-Archive -Path '%CONFIG_DIR%' -DestinationPath '!BACKUP!' -Force" 2>nul
        echo [*] Backup saved to: !BACKUP!
        
        rmdir /S /Q "%CONFIG_DIR%"
        echo [+] Removed %CONFIG_DIR%
    )
) else (
    echo [!] Configuration preserved at: %CONFIG_DIR%
)

echo.
echo ==============================================================================
echo        OFFENSIVE-CRAB-V1 Uninstalled Successfully
echo ==============================================================================
echo.

pause
endlocal
