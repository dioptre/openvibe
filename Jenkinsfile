node("${NodeName}") {
	// Add some informations about the build
	manager.addShortText("${params.BuildType}", "red", "white", "0px", "white")
	manager.addShortText("${NodeName}", "blue", "white", "0px", "white")

    def BuildOptions = [
        "Release" : "--release",
        "Debug" : "--debug"
        ]
    def BuildOption = BuildOptions[BuildType]
	
	git url: 'https://gitlab.inria.fr/openvibe/meta.git', branch: "master"
	shortCommitMeta = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
    manager.addShortText("Meta : ${params.SDKBranch} (${shortCommitMeta})", "black", "white", "0px", "white")

    stage('Build SDK') {
		dir("sdk") { 
			git url: 'https://gitlab.inria.fr/openvibe/sdk.git', branch: "${params.SDKBranch}"
			shortCommitSDK = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
			manager.addShortText("SDK : ${params.SDKBranch} (${shortCommitSDK})", "black", "white", "0px", "white")

			dir ("scripts") {
				if(isUnix()) {
					sh "./unix-build --build-type ${params.BuildType} --build-dir ${WORKSPACE}/build/sdk-${params.BuildType} --install-dir ${WORKSPACE}/dist/sdk-${params.BuildType} --dependencies-dir /builds/dependencies --test-data-dir /builds/dependencies/test-input --build-unit --build-validation"
				} else {
					error("TODO")
				}
			}
		}
    }
    stage('Tests SDK') {
        dir ("build/sdk-${params.BuildType}") {
			dir("unit-test/Testing") {
				deleteDir()
			}
			dir("validation-test/Testing") {
				deleteDir()
			}
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
		dir("designer") {
			git url: 'https://gitlab.inria.fr/openvibe/designer.git', branch: "${params.DesignerBranch}"
			shortCommitDesigner = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
			manager.addShortText("Designer : ${params.DesignerBranch} (${shortCommitDesigner})", "black", "white", "0px", "white")

			dir ("scripts") {
				if(isUnix()) {
					sh "./unix-build --build-type=${params.BuildType} --build-dir=${WORKSPACE}/build/designer-${params.BuildType} --install-dir=${WORKSPACE}/dist/designer-${params.BuildType} --sdk=${WORKSPACE}/dist/sdk-${params.BuildType}"
				} else {
					error("TODO")
				}
			}
		}
    }
    stage('Build Extras') {
		dir("extras") {
			git url: 'https://gitlab.inria.fr/openvibe/extras.git', branch: "${params.ExtrasBranch}"
			shortCommitExtras = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
			manager.addShortText("Extras : ${params.ExtrasBranch} (${shortCommitExtras})", "black", "white", "0px", "white")

			dir ("scripts") {
				if(isUnix()) {
					sh "./linux-build ${BuildOption} --build-dir ${WORKSPACE}/build/extras-${params.BuildType} --install-dir ${WORKSPACE}/dist/extras-${params.BuildType} --sdk ${WORKSPACE}/dist/sdk-${params.BuildType} --designer ${WORKSPACE}/dist/designer-${params.BuildType} --dependencies-dir /builds/dependencies"
				} else {
					error("TODO")
				}
			}
		}
    }
    stage('Tests Extras') {
        dir ("build/extras-${params.BuildType}") {
			dir("Testing") {
				deleteDir()
			}
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
	
	stage('Create Archive') {
		if(isUnix()) {
			dir("package") {
				deleteDir()
			}
			sh "./pack-release.sh"
		} else {
			error("TODO")
		}
	}
	
	stage('Test one click scripts') {
		dir("build") { 
			deleteDir()
		}
		if(isUnix()) {
			sh "./build.sh"
		} else {
			error("TODO")
		}
	}
}