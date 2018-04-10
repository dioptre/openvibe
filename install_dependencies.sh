#!/bin/bash

perl sdk/scripts/linux-install_dependencies.pl --manifest-dir sdk/scripts/ --dependencies-dir dependencies
perl sdk/scripts/linux-install_dependencies.pl --manifest-dir designer/scripts/ --dependencies-dir dependencies
perl sdk/scripts/linux-install_dependencies.pl --manifest-dir extras/scripts/ --dependencies-dir dependencies



