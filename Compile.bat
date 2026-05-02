@echo off
setlocal enabledelayedexpansion

:: Compilation Syntax -> Compile.bat 'D:\Coding\IOT\MyProject' COM5 12

:: ==============================
:: Arduino ESP32-S3 Build Script
:: Usage:
:: build_upload.bat "project_path" COMx jobs
:: Example:
:: build_upload.bat "D:\Coding\IOT\Test" COM5 8
:: ==============================

if "%~1"=="" (
    echo Usage:
    echo build_upload.bat "project_path" COMx jobs
    pause
    exit /b 1
)

:: Inputs
set PROJECT=%~1
set PORT=%~2
set JOBS=%~3

:: Defaults
if "%PORT%"=="" set PORT=COM3
if "%JOBS%"=="" set JOBS=8

:: Board
set FQBN=esp32:esp32:esp32s3

:: Build folder
set BUILD=%PROJECT%\build

echo.
echo ===============================
echo Project : %PROJECT%
echo Port    : %PORT%
echo Threads : %JOBS%
echo Board   : %FQBN%
echo ===============================
echo.

:: Compile
echo [1/2] Compiling...
arduino-cli compile ^
 --fqbn %FQBN% ^
 --build-path "%BUILD%" ^
 --jobs %JOBS% ^
 --build-property build.debug_level=none ^
 "%PROJECT%"

if errorlevel 1 (
    echo.
    echo COMPILATION FAILED
    pause
    exit /b 1
)

echo.
echo Compilation successful
echo.

:: Upload
echo [2/2] Uploading...
arduino-cli upload ^
 -p %PORT% ^
 --fqbn %FQBN% ^
 --input-dir "%BUILD%"

if errorlevel 1 (
    echo.
    echo UPLOAD FAILED
    echo If board did not auto-reset:
    echo Hold BOOT button and retry
    pause
    exit /b 1
)

echo.
echo ======================
echo UPLOAD SUCCESSFUL
echo ======================

pause