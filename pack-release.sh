#!/bin/bash
#
# Launch in the meta repo root after you've built the win installer manually by nsis
#

# todo could use the git tag?
OV_VERSION=2.0.1

rm package/*
mkdir package

tar --owner 0 --group 0 --transform s,^\.,openvibe-$OV_VERSION-src, --exclude ".git*" --exclude build --exclude dependencies --exclude dist --exclude  scripts/*.exe --exclude package -cJvf package/openvibe-$OV_VERSION-src.tar.xz .

pushd package

cp ../extras/scripts/openvibe-$OV_VERSION-setup.exe .

md5sum openvibe-$OV_VERSION-src.tar.xz >openvibe-$OV_VERSION-src.md5
md5sum openvibe-$OV_VERSION-setup.exe >openvibe-$OV_VERSION-setup.md5

popd

