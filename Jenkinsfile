node("${NodeName}") {
	// Add some informations about the build
	manager.addShortText("${params.BuildType}", "red", "white", "0px", "white")
	manager.addShortText("${NodeName}", "blue", "white", "0px", "white")

	def BuildOptions = [
		"Release" : "--release",
		"Debug" : "--debug"
		]
	def BuildOption = BuildOptions[BuildType]

	def build_dir = {
		if(isUnix()) {
			echo "${WORKSPACE}/build"
		} else {
			echo "${WORKSPACE}\build"
		}
	}

	def dist_dir = {
		if(isUnix()) {
			echo "${WORKSPACE}/build"
		} else {
			echo "${WORKSPACE}\build"
		}
	}
	def dependencies_dir = {
		if(isUnix()) {
			echo "/builds/dependencies"
		} else {
			error("TODO")
		}
	}
	
	git url: 'https://gitlab.inria.fr/openvibe/meta.git', branch: "master"
	shortCommitMeta = get_short_commit()
	manager.addShortText("Meta : ${params.SDKBranch} (${shortCommitMeta})", "black", "white", "0px", "white")

	stage('Build SDK') {
		dir("sdk") { 
			git url: 'https://gitlab.inria.fr/openvibe/sdk.git', branch: "${params.SDKBranch}"
			shortCommitSDK = get_short_commit()
			manager.addShortText("SDK : ${params.SDKBranch} (${shortCommitSDK})", "black", "white", "0px", "white")

			dir ("scripts") {
				if(isUnix()) {
					sh "./unix-build --build-type ${params.BuildType} --build-dir ${build_dir}/sdk-${params.BuildType} --install-dir ${dist_dir}/sdk-${params.BuildType} --dependencies-dir ${dependencies_dir} --test-data-dir ${dependencies_dir}/test-input --build-unit --build-validation"
				} else {
					bat "windows-build.cmd --no-pause ${BuildOption} --build-dir ${build_dir}\sdk-${params.BuildType} --install-dir ${dist_dir}\sdk-${params.BuildType} --dependencies-dir ${dependencies_dir} --userdata-subdir %UserDataSubdir% --build-unit --build-validation --test-data-dir ${dependencies_dir}\test-input"
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
				bat './ctest-launcher.cmd -T Test ; exit 0'
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
			shortCommitDesigner = get_short_commit()
			manager.addShortText("Designer : ${params.DesignerBranch} (${shortCommitDesigner})", "black", "white", "0px", "white")

			dir ("scripts") {
				if(isUnix()) {
					sh "./unix-build --build-type=${params.BuildType} --build-dir=${build_dir}/designer-${params.BuildType} --install-dir=${dist_dir}/designer-${params.BuildType} --sdk=${dist_dir}/sdk-${params.BuildType}"
				} else {
					bat "windows-build.cmd --no-pause ${BuildOption} --build-dir ${build_dir}\designer-${params.BuildType} --install-dir ${dist_dir}\designer-${params.BuildType} --sdk ${dist_dir}\sdk-${params.BuildType} --dependencies-dir ${dependencies_dir} --userdata-subdir %UserDataSubdir%"
				}
			}
		}
	}
	stage('Build Extras') {
		dir("extras") {
			git url: 'https://gitlab.inria.fr/openvibe/extras.git', branch: "${params.ExtrasBranch}"
			shortCommitExtras = get_short_commit()
			manager.addShortText("Extras : ${params.ExtrasBranch} (${shortCommitExtras})", "black", "white", "0px", "white")

			dir ("scripts") {
				if(isUnix()) {
					sh "./linux-build ${BuildOption} --build-dir ${build_dir}/extras-${params.BuildType} --install-dir ${dist_dir}/extras-${params.BuildType} --sdk ${dist_dir}/sdk-${params.BuildType} --designer ${dist_dir}/designer-${params.BuildType} --dependencies-dir ${dependencies_dir}"
				} else {
					bat "win32-build.cmd --no-pause ${BuildOption} --build-dir ${build_dir}\extras-${params.BuildType} --install-dir ${dist_dir}\extras-${params.BuildType} --sdk ${dist_dir}\sdk-${params.BuildType} --designer ${dist_dir}\designer-${params.BuildType} --dependencies-dir ${dependencies_dir} --userdata-subdir %UserDataSubdir%"
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
				bat "ctest -T Test ; exit 0"
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
def get_short_commit() {
	if(isUnix()) {
		sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
	} else {
		bat(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
	}
}