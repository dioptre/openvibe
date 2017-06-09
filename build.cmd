@echo off
setlocal EnableDelayedExpansion
setlocal enableextensions 

set BuildType=Release
set BuildOption=--release
set base_dir=%~dp0
set build_dir_base=%base_dir%\build
set install_dir_base=%base_dir%\dist
set dependencies_dir_studio=%base_dir%\certivibe\dependencies

:parameter_parse
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
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--debug" (
	set BuildType=Debug	
	set BuildOption=--debug
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="-r" (
	set BuildType=Release
	set BuildOption=--release
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--release" (
	set BuildType=Release
	set BuildOption=--release
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--build-dir" (
	set build_dir_base=%2
	SHIFT
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--install-dir" (
	set install_dir_base=%2
	SHIFT
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--dependencies-dir" (
	set dependencies_dir=--dependencies-dir %2
	set dependencies_dir_studio=%2
	SHIFT
	SHIFT
	Goto parameter_parse
)

set base_dir=%~dp0
echo Building certivibe
cd %base_dir%\certivibe\scripts
call windows-build.cmd --no-pause %BuildOption% --build-dir %build_dir_base%\certivibe-%BuildType% --install-dir %install_dir_base%\certivibe-%BuildType% %dependencies_dir%

echo Building studio
cd %base_dir%\studio\scripts
call windows-build.cmd --no-pause %BuildOption% --build-dir %build_dir_base%\studio-%BuildType% --install-dir %install_dir_base%\studio-%BuildType% --sdk %install_dir_base%\certivibe-%BuildType% %dependencies_dir%

echo Building extras
cd %base_dir%\openvibe\scripts
call win32-build.cmd --no-pause %BuildOption% --build-dir %build_dir_base%\openvibe-%BuildType% --install-dir %install_dir_base%\openvibe-%BuildType% --certsdk %install_dir_base%\studio-%BuildType% --studiosdk %install_dir_base%\studio-%BuildType% %dependencies_dir%
