#!/bin/bash

rm -rf /tmp/ov.*
rm -rf ~/test

branch_cert=master
branch_certtest=master
branch_designer=master
branch_extras=wip-thga-fix-ci

BuildType=Release
# prefix=
# install_dir_base=
# build_dir_base=

git clone git@github.com:mensiatech/certivibe.git -b ${branch_cert} sdk
#ssh-agent bash -c "ssh-add ~/.ssh/id_rsa2; git clone git@github.com:mensiatech/certivibe-test.git -b ${branch_certtest} sdktest"
git clone git@bitbucket.org:mensiatech/studio.git -b ${branch_designer} designer
git clone https://scm.gforge.inria.fr/anonscm/git/openvibe/openvibe.git -b ${branch_extras} extras

cd ~/sdk/scripts
./unix-build --build-type ${BuildType} --build-dir /builds/build/sdk-${BuildType} --install-dir /builds/dist/sdk-${BuildType} --dependencies-dir /builds/dependencies --gtest-lib-dir /builds/dependencies/libgtest --test-data-dir /builds/dependencies/test-input --build-unit --build-validation

cd ~/build/sdk-${BuildType}
./ctest-launcher.sh

#cd ~/sdktest/scripts
#./unix-robot-launcher.sh --ov-root /builds/dist/sdk-${BuildType}

cd ~/designer/scripts
./unix-build --build-type=${BuildType} --build-dir=/builds/build/designer-${BuildType} --install-dir=/builds/dist/designer-${BuildType} --sdk=/builds/dist/sdk-${BuildType}

cd ~/extras/scripts
./linux-build ${BuildOption} --build-dir /builds/build/extras-${BuildType} --install-dir /builds/dist/extras-${BuildType} --sdk /builds/dist/sdk-${BuildType} --designer /builds/dist/designer-${BuildType} --dependencies-dir /builds/dependencies

export DISPLAY=:0.0
cd  ~/build/extras-${BuildType}
ctest -T Test
# LC_ALL=C ctest -VV -S openVibeTests.cmake,Nightly -DCTEST_SITE="ci@$SLAVE_NAME.ci"