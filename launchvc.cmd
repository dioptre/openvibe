@echo off

set PATH=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin;%PATH%
set BuildType=Release
set builddir=%CD%\build
set USE_EXPRESS=0

for %%A in (%*) DO (
	if /i "%%A"=="--debug" (
		set BuildType=Debug
	)
)



set SDKPath=%builddir%\sdk-%BuildType%\OpenVIBE.sln
set DesignerPath=%builddir%\designer-%BuildType%\Designer.sln
set ExtrasPath=%builddir%\extras-%BuildType%\OpenVIBE.sln

REM SET "OV_PATH_ROOT=%CD%\..\..\certivibe-build\dist-%BuildType%"
REM SET "OV_PATH_BIN=%OV_PATH_ROOT%\bin"
REM SET "OV_PATH_DATA=%OV_PATH_ROOT%\share\openvibe"
REM SET "OV_PATH_LIB=%OV_PATH_ROOT%\bin"
REM SET "PATH=%OV_PATH_ROOT%\bin;%PATH%"


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
	start /b "%VSINSTALLDIR%\Common7\IDE\devenv.exe" %SDKPath%
	start /b "%VSINSTALLDIR%\Common7\IDE\devenv.exe" %DesignerPath%
	start /b "%VSINSTALLDIR%\Common7\IDE\devenv.exe" %ExtrasPath%
)