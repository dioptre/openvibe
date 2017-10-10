@echo off
setlocal EnableDelayedExpansion
setlocal enableextensions 

set base_dir=%~dp0
set dependencies_dir=%base_dir%\dependencies

REM As long as the sdk/designer dependencies are hosted within Mensia, 
REM you need to provide credentials below...
set PROXYPASS=
set URL=https://extranet.mensiatech.com/dependencies

:parameter_parse
if /i "%1"=="-h"  (
	echo Usage: install_dependencies.cmd [--dependencies-dir directory]
	echo -- 
	pause
	exit /B 0
) else if /i "%1"=="--help" (
	echo Usage: install_dependencies.cmd [--dependencies-dir directory]
	echo -- 
	pause
	exit /B 0	
) else if /i "%1"=="--dependencies-dir" (
	set dependencies_dir=%2
	SHIFT
	SHIFT
	Goto parameter_parse
)

if not exist "%dependencies_dir%\arch\data" ( mkdir "%dependencies_dir%\arch\data" )
if not exist "%dependencies_dir%\arch\build\windows" ( mkdir "%dependencies_dir%\arch\build\windows" )
if not exist "%dependencies_dir%_x64\arch\build\windows" ( mkdir "%dependencies_dir%_x64\arch\build\windows" )

set base_dir=%~dp0
echo Installing sdk dependencies
cd %base_dir%\sdk\scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-get-dependencies.ps1" -manifest_file .\windows-dependencies-x86.txt -dest_dir %dependencies_dir%
powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-get-dependencies.ps1" -manifest_file .\tests-data.txt -dest_dir %dependencies_dir%
if !errorlevel! neq 0 (
	echo Error while installing SDK dependencies
	exit /b !errorlevel!
)

echo Installing Designer dependencies
cd %base_dir%\designer\scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-get-dependencies.ps1" -manifest_file .\windows-dependencies.txt -dest_dir %dependencies_dir%
if !errorlevel! neq 0 (
	echo Error while installing Designer dependencies
	exit /b !errorlevel!
)

REM The 'extras' dependencies are hosted by Inria ...
set PROXYPASS=anon:anon
set URL=http://openvibe.inria.fr/dependencies/win32/2.0.0/

echo Installing OpenViBE extras dependencies
cd %base_dir%\extras\scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-get-dependencies.ps1" -manifest_file .\windows-dependencies.txt -dest_dir %dependencies_dir%
if !errorlevel! neq 0 (
	echo Error while building extras
	exit /b !errorlevel!
)

echo Creating OpenViBE extras dependency path setup script
set "dependency_cmd=%dependencies_dir%\win32-dependencies.cmd"
echo @ECHO OFF >%dependency_cmd%
echo. >>%dependency_cmd%
echo SET "dependencies_base=%dependencies_dir%" >>%dependency_cmd%
echo. >>%dependency_cmd%
type %base_dir%\extras\scripts\win32-dependencies.cmd-base >>%dependency_cmd%

echo Done.

