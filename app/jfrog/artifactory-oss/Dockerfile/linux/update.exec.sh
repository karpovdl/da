#!/bin/bash

#./update.exec.sh

#$1 - app name
#$2 - version application prev
#$3 - version application next
#$4 - app port
#$5 - sub path for data folder
#$6 - docker id

#./update.exec.sh {APP_NAME} {VERSION_PREV} {VERSION_NEXT} {APP_PORT} {DATA_DIR} {DOCKER_ID}

./update.sh \
 jfrog-artifactory-oss \
 7.4.3 \
 7.5.5 \
 8091 \
 /assets/app/jfrog/artifactory_data \
 karpovdl
