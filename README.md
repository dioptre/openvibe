|OpenViBE meta repository| |README|  
===================================
Build Status :  
- Ubuntu 16.04 [![Build Status](https://ci.inria.fr/openvibe-qualif/buildStatus/icon?job=OpenViBE-Nightly-Ubuntu16.04&style=plastic)](https://ci.inria.fr/openvibe-qualif/job/OpenViBE-Nightly-Ubuntu16.04)
- Fedora 25 [![Build Status](https://ci.inria.fr/openvibe-qualif/buildStatus/icon?job=OpenViBE-Nightly-Fedora25&style=plastic)](https://ci.inria.fr/openvibe-qualif/job/OpenViBE-Nightly-Fedora25)

OpenViBE project is now divided into 3 parts :   
- SDK, that contains the certifiable core and plugins of OpenViBE
- Designer, the graphical interface for OpenViBE
- Extras, for community plugins and contributions

The current repository, OpenViBE-meta, exist to ease the task of building these repositories together.

To build OpenViBE, follow these instructions :
- Pull this repository
- Pull its submodules
- Install the dependencies using install_dependencies.cmd or .sh script, depending on your platform
- Build the project using build.cmd or build.sh script
    - OPTIONNAL : if you need a solution that can be opened in visual studio, add --vsbuild-all flag. Generated solution will be outputted in build folder
    

## Pulling this repository
This can be done using "git pull git@gitlab.inria.fr:openvibe/meta.git" from command line, or with any GUI for git, like GitKraken.

## Pulling the submodules
Please note that you will require a recent version of git for this step; we advise to use versions above 2.0, but git 1.7 should work.
Use "git submodule update --init --recursive" to fetch all submodules.

## Installing the dependencies
Call install_dependencies.cmd or install_dependencies.sh, depending on your system.
A "dependencies" folder will be created on main directory.

## Building the project
To build the whole project, execute build.cmd (windows) or build.sh (linux).
You will require at least version 2013 of Visual Studio, or GCC 4.8

## Building the project for Visual Studio
To build the project for visual studio with both debug and release, use "build.cmd --vsbuild-all".
After building the project, the script will attempt to generate a merged solution of the 3 projects.
This requires python3 and jinja2.
If you use stock python3, you can install jinja2 like so :
	c:\python3X\Scripts\pip.exe install jinja2
The merged sln will be generated in the build directory.

If you do not wish to install python, you can also use the launchvc.cmd or launchvc_debug.cmd scripts (Legacy)

## Updating the repository
### WARNING : I HAVE NO IDEA HOW IT BEHAVE IF YOU HAVE PERSONNAL COMMIT/UNCOMMITED FILES
You can update the whole directory (including submodules) with :
git pull
git submodule sync --recursive
git submodule update -–init --recursive

Aliases can be created to ease the global update process :
git config --global alias.spull '!git pull && git submodule sync --recursive && git submodule update --init --recursive'
### END WARNING



