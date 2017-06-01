#!/bin/bash

BuildType=Release
BuildOption=--release
base_dir=$(dirname "$(readlink -f "$0")")
build_dir_base="${base_dir}/build"
install_dir_base= "${base_dir}/dist"
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
			build_dir_base="$2"
			shift
			;;
		--install-dir)
			install_dir_base="$2"
			shift
			;;
		*)
			echo "ERROR: Unknown parameter $i"
			exit 1
			;;
	esac
	shift
done

echo Building certivibe
cd ${base_dir}/certivibe/scripts
call windows-build.cmd ${BuildOption} --build-dir ${build_dir_base}/certivibe-${BuildType} --install-dir ${install_dir_base}/certivibe-${BuildType}

echo Building studio
cd ${base_dir}/studio/scripts
call windows-build.cmd ${BuildOption} --build-dir ${build_dir_base}/studio-${BuildType} --install-dir ${install_dir_base}/studio-${BuildType} --sdk ${install_dir_base}/certivibe-${BuildType} --dep ${base_dir}/certivibe/dependencies

echo Building extras
cd ${base_dir}/openvibe/scripts
call win32-build.cmd ${BuildOption} --build-dir ${build_dir_base}/openvibe-${BuildType} --install-dir ${install_dir_base}/openvibe-${BuildType} --studiosdk ${install_dir_base}/studio-${BuildType} 
