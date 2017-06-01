#!/bin/bash

BuildType=Release
BuildOption=--release

while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		-h | --help)
			echo "-d | --debug : build as debug"
			echo "-r | --release : build as release"
			echo "--build-dir <dirname> : directory for build files"
			echo "--install-dir <dirname> : binaries deployment directory"
			exit
			;;
		-d | --debug)
			BuildType=Debug
			BuildOption=--debug
			;;
		-r | --release)
			BuildType=Release
			BuildOption=--release
			;;
		--build-dir)
			ov_build_dir="$2"
			shift
			;;
		--install-dir)
			ov_install_dir="$2"
			shift
			;;
		*)
			echo "ERROR: Unknown parameter $i"
			exit 1
			;;
	esac
	shift
done

set base_dir=$(dirname "$(readlink -f "$0")")
echo Building certivibe
cd ${base_dir}/certivibe/scripts
call windows-build.cmd ${BuildOption} --build-dir ${base_dir}/build/certivibe-${BuildType} --install-dir ${base_dir}/dist/certivibe-${BuildType}

echo Building studio
cd ${base_dir}/studio/scripts
call windows-build.cmd ${BuildOption} --build-dir ${base_dir}/build/studio-${BuildType} --install-dir ${base_dir}/dist/studio-${BuildType} --sdk ${base_dir}/dist/certivibe-${BuildType} --dep ${base_dir}/certivibe/dependencies

echo Building extras
cd ${base_dir}/openvibe/scripts
call win32-build.cmd ${BuildOption} --build-dir ${base_dir}/build/openvibe-${BuildType} --install-dir ${base_dir}/dist/openvibe-${BuildType} --studiosdk ${base_dir}/dist/studio-${BuildType} 
