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

echo Building extras
cd ${base_dir}/extras/scripts
./unix-build ${BuildOption} --build-dir ${build_dir_base}/extras-${BuildType} --install-dir ${install_dir_base}/extras-${BuildType}

echo Building designer
cd ${base_dir}/designer/scripts
./unix-build ${BuildOption} --build-dir ${build_dir_base}/designer-${BuildType} --install-dir ${install_dir_base}/designer-${BuildType} --sdk ${install_dir_base}/extras-${BuildType} --dep ${base_dir}/extras/dependencies

echo Building extras
cd ${base_dir}/extras/scripts
linux-build ${BuildOption} --build-dir ${build_dir_base}/extras-${BuildType} --install-dir ${install_dir_base}/extras-${BuildType} --studiosdk ${install_dir_base}/designer-${BuildType} 
