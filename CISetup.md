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
* Windows Slaves Plugins

# Jenkins jobs
* OpenViBE-Generic     Base job : Uses JenkinsFile in meta repo + config is in jenkins-config.xml file.
* OpenViBE-Nightly-*   Identical to Generic, but with a nightly job + diverse default systems.

# Backup/Restore Jenkins job config
See https://www.sghill.net/how-do-i-backup-jenkins-jobs.html or use Jenkins-cli (did not manage to use it on inria platform)

# Windows machines
Microsoft website doesn't list the old versions of VS
You can get vs 2013 at this link : http://download.microsoft.com/download/7/2/E/72E0F986-D247-4289-B9DC-C4FB07374894/wdexpress_full.exe
Python 3.4+ should be installed + numpy

# Linux machines
Package xvfb is required