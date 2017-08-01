@echo off
setlocal EnableDelayedExpansion
setlocal enableextensions 

set BuildType=Release
set BuildOption=--release
set base_dir=%~dp0
set build_dir_base=%base_dir%\build
set install_dir_base=%base_dir%\dist
set dependencies_dir=%base_dir%\dependencies
SET PYTHONHOME=C:\Anaconda3
SET PYTHONPATH=C:\Anaconda3\Lib

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
	set dependencies_dir=%2
	SHIFT
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--vsproject" (
	set vsbuild=--vsproject
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--vsbuild" (
	set vsbuild=--vsbuild
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--vsbuild-all" (
	set multibuild_all=TRUE
	SHIFT
	Goto parameter_parse
)

if not defined multibuild_all (
	echo Building sdk
	cd %base_dir%\sdk\scripts
	call windows-build.cmd --no-pause %vsbuild% %BuildOption% --build-dir %build_dir_base%\sdk-%BuildType% --install-dir %install_dir_base%\sdk-%BuildType% --dependencies-dir %dependencies_dir% --build-unit --build-validation
	if !errorlevel! neq 0 (
		echo Error while building sdk
		exit /b !errorlevel!
	)

	echo Building designer
	cd %base_dir%\designer\scripts
	call windows-build.cmd --no-pause %vsbuild% %BuildOption% --build-dir %build_dir_base%\designer-%BuildType% --install-dir %install_dir_base%\designer-%BuildType% --sdk %install_dir_base%\sdk-%BuildType% --dependencies-dir %dependencies_dir%
	if !errorlevel! neq 0 (
		echo Error while building designer
		exit /b !errorlevel!
	)

	echo Building extras
	cd %base_dir%\extras\scripts
	call win32-build.cmd --no-pause %vsbuild% %BuildOption% --build-dir %build_dir_base%\extras-%BuildType% --install-dir %install_dir_base%\extras-%BuildType% --sdk %install_dir_base%\sdk-%BuildType% --designer %install_dir_base%\designer-%BuildType% --dependencies-dir %dependencies_dir%
	if !errorlevel! neq 0 (
		echo Error while building extras
		exit /b !errorlevel!
	)
) else (
	echo Building sdk
	cd %base_dir%\sdk\scripts
	call windows-build.cmd --no-pause --vsbuild --debug --build-dir %build_dir_base%\sdk --install-dir %install_dir_base%\sdk --dependencies-dir %dependencies_dir% --build-unit --build-validation 
	call windows-build.cmd --no-pause --vsbuild --release --build-dir %build_dir_base%\sdk --install-dir %install_dir_base%\sdk --dependencies-dir %dependencies_dir% --build-unit --build-validation 

	echo Building designer
	cd %base_dir%\designer\scripts
	call windows-build.cmd --no-pause --vsbuild --debug --build-dir %build_dir_base%\designer --install-dir %install_dir_base%\designer --sdk %install_dir_base%\sdk --dependencies-dir %dependencies_dir%
	call windows-build.cmd --no-pause --vsbuild --release --build-dir %build_dir_base%\designer --install-dir %install_dir_base%\designer --sdk %install_dir_base%\sdk --dependencies-dir %dependencies_dir%

	echo Building extras
	cd %base_dir%\extras\scripts
	call win32-build.cmd --no-pause --vsbuild --debug --build-dir %build_dir_base%\extras --install-dir %install_dir_base%\extras --sdk %install_dir_base%\sdk --designer %install_dir_base%\designer --dependencies-dir %dependencies_dir%
	call win32-build.cmd --no-pause --vsbuild --release --build-dir %build_dir_base%\extras --install-dir %install_dir_base%\extras --sdk %install_dir_base%\sdk --designer %install_dir_base%\designer --dependencies-dir %dependencies_dir%
	
	echo Generating meta project
	if defined vsbuild (
		call python.exe generateVS.py --build-dir %build_dir_base%
	)
)
