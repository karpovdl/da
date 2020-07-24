#!/bin/bash

#golang
#./run.sh

#$1 - docker id (mandatory parameter)
#$2 - version golang (mandatory parameter)
#$3 - version alpine (optional parameter)

#./builder.sh {DOCKER_ID} {VERSION}
#./builder.sh {DOCKER_ID} {VERSION} {VERSION_ALPINE}
./builder.sh karpovdl 1.14.6 3.12
