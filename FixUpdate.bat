@echo off
:: Windows Update Repair Script with Logging
:: Must be run as Administrator

set LOGFILE=%~dp0FixWindowsUpdate_%DATE:~-4%-%DATE:~4,2%-%DATE:~7,2%.log

:: Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo This script requires administrator privileges.
    echo Right-click and select "Run as administrator".
    pause
    exit /b
)

(
echo =====================================
echo Windows Update Repair Script Started - %date% %time%
echo Log File: %LOGFILE%
echo =====================================

echo.
echo Stopping Windows Update services...
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver

echo.
echo Renaming SoftwareDistribution and Catroot2...
ren %systemroot%\SoftwareDistribution SoftwareDistribution.bak
ren %systemroot%\System32\catroot2 Catroot2.bak

echo.
echo Starting Windows Update services...
net start wuauserv
net start cryptSvc
net start bits
net start msiserver

echo.
echo Running System File Checker (SFC)...
sfc /scannow

echo.
echo Running DISM Health Restore...
DISM /Online /Cleanup-Image /RestoreHealth

echo.
echo =====================================
echo Script execution complete.
echo Please restart your computer if prompted.
echo =====================================
) >> "%LOGFILE%" 2>&1

echo.
echo Done! A log has been saved to:
echo %LOGFILE%
echo.
pause
