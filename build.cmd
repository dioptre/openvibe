REM @echo off
setlocal EnableDelayedExpansion
setlocal enableextensions 

set BuildType=Release
set BuildOption=--release
if /i "%1"=="-h" (
	echo Usage: win32-build.cmd [Build Type] [Init-env Script]
	echo -- Build Type option can be : --release (-r^), --debug (-d^). Default is Release.
	pause
	exit 0
) else if /i "%1"=="--help" (
	echo Usage: win32-build.cmd [Build Type] [Init-env Script]
	echo -- Build Type option can be : --release (-r^), --debug (-d^). Default is Release.
	pause
	exit 0
) else if /i "%1"=="-d" (
	set BuildType=Debug
	set BuildOption=--debug
) else if /i "%1"=="--debug" (
	set BuildType=Debug	
	set BuildOption=--debug
) else if /i "%1"=="-r" (
	set BuildType=Release
	set BuildOption=--release
) else if /i "%1"=="--release" (
	set BuildType=Release
	set BuildOption=--release
)

set base_dir=%~dp0
echo Building certivibe
cd %base_dir%\certivibe\scripts
call windows-build.cmd --no-pause %BuildOption% --build-dir %base_dir%\build\certivibe-%BuildType% --install-dir %base_dir%\dist\certivibe-%BuildType%

echo Building studio
cd %base_dir%\studio\scripts
call windows-build.cmd --no-pause %BuildOption% --build-dir %base_dir%\build\studio-%BuildType% --install-dir %base_dir%\dist\studio-%BuildType% --sdk %base_dir%\dist\certivibe-%BuildType% --dep %base_dir%\certivibe\dependencies

echo Building extras
cd %base_dir%\openvibe\scripts
call win32-build.cmd --no-pause %BuildOption% --build-dir %base_dir%\build\openvibe-%BuildType% --install-dir %base_dir%\dist\openvibe-%BuildType% --studiosdk %base_dir%\dist\studio-%BuildType% 
