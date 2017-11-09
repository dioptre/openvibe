# Jenkins plugins

Most of them are in the base install.
* Git
* Git Parameter Plug-In 
* Pipelines
* Node and Label parameter
* Xvfb
* XUnit
* embeddable-build-status (Optional - for build status icon)
* Groovy Postbuild (Optional - to show build status in history)

# Jenkins jobs
* OpenViBE-Generic     Base job : Uses JenkinsFile in meta repo + config is in jenkins-config.xml file.
* OpenViBE-Nightly-*   Identical to Generic, but with a nightly job + diverse default systems.

# Backup/Restore Jenkins job config
See https://www.sghill.net/how-do-i-backup-jenkins-jobs.html or use Jenkins-cli (did not manage to use it on inria platform)
