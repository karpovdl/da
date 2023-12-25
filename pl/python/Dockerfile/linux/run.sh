#!/bin/bash

#python
#./run.sh

#$1 - docker id (mandatory parameter)
#$2 - version python (mandatory parameter)
#$3 - version alpine (optional parameter)

#./builder.sh {DOCKER_ID} {VERSION}
#./builder.sh {DOCKER_ID} {VERSION} {VERSION_ALPINE}
./builder.sh karpovdl 3.9.18 3.19

#./builder_dev_version.sh {DOCKER_ID} {VERSION}
#./builder_dev_version.sh {DOCKER_ID} {VERSION} {VERSION_ALPINE}
# Add packeges python
./builder_dev_version.sh karpovdl 3.9.18 3.19