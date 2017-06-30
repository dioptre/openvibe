@echo off
setlocal EnableDelayedExpansion
setlocal enableextensions 

set base_dir=%~dp0
set dependencies_dir=%base_dir%\dependencies

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

set base_dir=%~dp0
echo Installing sdk dependencies
cd %base_dir%\sdk\scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-install-dependencies.ps1" -manifest_file .\windows-dependencies.txt -dest_dir %dependencies_dir% -lazy
powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-install-dependencies.ps1" -manifest_file .\tests-data.txt -dest_dir %dependencies_dir% -lazy
if !errorlevel! neq 0 (
	echo Error while installing SDK dependencies
	exit /b !errorlevel!
)

echo Installing Designer dependencies
cd %base_dir%\designer\scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-install-dependencies.ps1" -manifest_file .\windows-dependencies.txt -dest_dir %dependencies_dir% -lazy
rem powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-install-dependencies.ps1" -manifest_file .\windows-dependencies-sdk.txt -dest_dir %dependencies_dir% -lazy
if !errorlevel! neq 0 (
	echo Error while installing Designer dependencies
	exit /b !errorlevel!
)

echo Installing OpenViBE extras dependencies
cd %base_dir%\extras\scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-install-dependencies.ps1" -manifest_file .\windows-dependencies.txt -dest_dir %dependencies_dir% -lazy
if !errorlevel! neq 0 (
	echo Error while building extras
	exit /b !errorlevel!
)

