node("${params.NodeName}") {
    def BuildOptions = [
        "Release" : "--release",
        "Debug" : "--debug"
        ]
    def BuildOption = BuildOptions[BuildType]
    stage('Build SDK') {
		git url: 'git@github.com:mensiatech/certivibe.git', branch: "${params.SDKBranch}"
        dir ("scripts") {
            if(isUnix()) {
                sh "echo ${params.BuildType}"
                sh "./unix-build --build-type ${params.BuildType} --build-dir ${WORKSPACE}/build/sdk-${params.BuildType} --install-dir ${WORKSPACE}/dist/sdk-${buildtype} --dependencies-dir /builds/dependencies --gtest-lib-dir /builds/dependencies/libgtest --test-data-dir /builds/dependencies/test-input --build-unit --build-validation"
            } else {
                error("TODO")
            }
        }
    }
    stage('Tests SDK') {
        dir ("build/sdk-${params.BuildType}") {
            if(isUnix()) {
                sh './ctest-launcher.sh -T Test ; exit 0'
            } else {
                error("TODO")
            }
            step([$class: 'XUnitBuilder',
                thresholds: [[$class: 'FailedThreshold', unstableThreshold: '0']],
                tools: [[$class: 'CTestType', pattern: "unit-test/Testing/*/Test.xml"],
                        [$class: 'CTestType', pattern: "validation-test/Testing/*/Test.xml"],]
            ])
        }
    }
    stage('Build Designer') {
		git url: 'git@bitbucket.org:mensiatech/studio.git', branch: "${params.DesignerBranch}"
        dir ("scripts") {
            if(isUnix()) {
                sh "./unix-build --build-type=${params.BuildType} --build-dir=${WORKSPACE}/build/designer-${params.BuildType} --install-dir=${WORKSPACE}/dist/designer-${params.BuildType} --sdk=${WORKSPACE}/dist/sdk-${params.BuildType}"
            } else {
                error("TODO")
            }
        }
    }
    stage('Build Extras') {
		git url: 'https://scm.gforge.inria.fr/anonscm/git/openvibe/openvibe.git', branch: "${params.ExtrasBranch}"
        dir ("scripts") {
            if(isUnix()) {
                sh "./linux-build ${BuildOption} --build-dir ${WORKSPACE}/build/extras-${params.BuildType} --install-dir ${WORKSPACE}/dist/extras-${params.BuildType} --sdk ${WORKSPACE}/dist/sdk-${params.BuildType} --designer ${WORKSPACE}/dist/designer-${params.BuildType} --dependencies-dir /builds/dependencies"
            } else {
                error("TODO")
            }
        }
    }
    stage('Tests Extras') {
        dir ("build/extras-${params.BuildType}") {
            if(isUnix()) {
                wrap([$class: 'Xvfb']) {
                    sh "ctest -T Test ; exit 0"
                }
            } else {
                error("TODO")
            }
            step([$class: 'XUnitBuilder',
                thresholds: [[$class: 'FailedThreshold', unstableThreshold: '0']],
                tools: [[$class: 'CTestType', pattern: "Testing/*/Test.xml"],]
            ])
        }
    }
}
