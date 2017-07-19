@echo off
setlocal EnableDelayedExpansion
setlocal enableextensions 

set "script_dir=%~dp0"
set BuildType=Release
set builddir=%script_dir%\build
set USE_EXPRESS=0

for %%A in (%*) DO (
	if /i "%%A"=="--debug" (
		set BuildType=Debug
	)
)
set PATH_DEPENDENCIES=%script_dir%\dependencies
set SDKPath=%builddir%\sdk-%BuildType%\OpenVIBE.sln
set DesignerPath=%builddir%\designer-%BuildType%\Designer.sln
set ExtrasPath=%builddir%\extras-%BuildType%\OpenVIBE.sln

SET "OV_PATH_ROOT=%script_dir%\dist\sdk-%BuildType%"
SET "DESIGNER_PATH_ROOT=%script_dir%\dist\designer-%BuildType%"
SET "EXTRAS_PATH_ROOT=%script_dir%\dist\extras-%BuildType%"
set args=%PATH_DEPENDENCIES%
SET "PATH=%EXTRAS_PATH_ROOT%\bin;%DESIGNER_PATH_ROOT%\bin;%OV_PATH_ROOT%\bin;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin;%PATH%"

call :addToPathIfExists cmake\bin
call :addToPathIfExists ninja
call :addToPathIfExists expat\bin
call :addToPathIfExists itpp\bin
call :addToPathIfExists lua\lib
call :addToPathIfExists gtk\bin
call :addToPathIfExists cegui\bin
call :addToPathIfExists cegui\dependencies\bin
call :addToPathIfExists pthreads\lib
call :addToPathIfExists openal\libs\win32
call :addToPathIfExists freealut\lib
call :addToPathIfExists libogg\win32\bin\release
call :addToPathIfExists libogg\win32\bin\debug
call :addToPathIfExists libvorbis\win32\bin\release
call :addToPathIfExists libvorbis\win32\bin\debug
call :addToPathIfExists liblsl\lib
call :addToPathIfExists ogre\bin\release
call :addToPathIfExists ogre\bin\debug
call :addToPathIfExists vrpn\bin
call :addToPathIfExists openal\libs\Win32
call :addToPathIfExists liblsl\lib
call :addToPathIfExists sdk-brainproducts-actichamp
call :addToPathIfExists sdk-mcs\lib
call :addToPathIfExists xerces-c\lib
call :addToPathIfExists vcredist
call :addToPathIfExists boost\bin
call :addToPathIfExists tvicport\bin
call :addToPathIfExists vcredist
call :addToPathIfExists zip
echo !PATH!

if not defined SKIP_VS2017 (
	SET SKIP_VS2017=1
)
if not defined SKIP_VS2015 (
	SET SKIP_VS2015=1
)
if not defined SKIP_VS2013 (
	SET SKIP_VS2013=0
)

set VSTOOLS=
set VSCMake=

if %SKIP_VS2017% == 1 (
	echo Visual Studio 2017 detection skipped as requested
) else (
	if exist "%VS150COMNTOOLS%vsvars32.bat" (
		echo Found VS150 tools at "%VS150COMNTOOLS%" ...
		CALL "%VS150COMNTOOLS%vsvars32.bat"
		SET VSCMake=Visual Studio 15
		goto launch
	)
)

if %SKIP_VS2015% == 1 (
	echo Visual Studio 2015 detection skipped as requested
) else (
	if exist "%VS140COMNTOOLS%vsvars32.bat" (
		echo Found VS140 tools at "%VS140COMNTOOLS%" ...
		CALL "%VS140COMNTOOLS%vsvars32.bat"
		SET VSCMake=Visual Studio 14
		goto launch
	)
)

if %SKIP_VS2013% == 1 (
	echo Visual Studio 2013 detection skipped as requested
) else (
	if exist "%VS120COMNTOOLS%vsvars32.bat" (
		echo Found VS120 tools at "%VS120COMNTOOLS%" ...
		CALL "%VS120COMNTOOLS%vsvars32.bat"
		SET VSCMake=Visual Studio 12
		goto launch
	)
)

goto launch

:addToPathIfExists
for %%A in (%args%) DO (
	if exist "%%A\%~1\" (
		set "PATH=%%A\%~1;!PATH!"
	)
)
exit /B 0


:launch

if %USE_EXPRESS% == 1 (
	echo Use %VSCMake% Express Edition
	
	if "%VSCMake%"=="Visual Studio 12"  (
		start /b "%VSINSTALLDIR%\Common7\IDE\WDExpress.exe" %SDKPath%
	) else (
		"%VSINSTALLDIR%\Common7\IDE\VCExpress.exe" %SDKPath%
	)
) else (
	echo Use %VSCMake%
	REM SET "OV_PATH_BIN=%script_dir%\dist\sdk-%BuildType%\bin"
	REM SET "OV_PATH_LIB=%script_dir%\dist\sdk-%BuildType%\bin"
	REM set "OV_PATH_DATA=%script_dir%\dist\sdk-%BuildType%\share\openvibe"
	REM start /b "" "%VSINSTALLDIR%\Common7\IDE\devenv.exe" %SDKPath%
	REM SET "OV_PATH_BIN=%script_dir%\dist\designer-%BuildType%\bin"
	REM SET "OV_PATH_LIB=%script_dir%\dist\designer-%BuildType%\bin"
	REM set "OV_PATH_DATA=%script_dir%\dist\designer-%BuildType%\share\openvibe"
	REM start /b "" "%VSINSTALLDIR%\Common7\IDE\devenv.exe" %DesignerPath%
	SET "OV_PATH_BIN=%script_dir%\dist\extras-%BuildType%\bin"
	SET "OV_PATH_LIB=%script_dir%\dist\extras-%BuildType%\bin"
	set "OV_PATH_DATA=%script_dir%\dist\extras-%BuildType%\share\openvibe"
	start /b "" "%VSINSTALLDIR%\Common7\IDE\devenv.exe" %ExtrasPath%
)