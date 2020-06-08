#!/bin/bash

#./update.exec.sh

#$1 - app name
#$2 - version application prev
#$3 - version application next
#$4 - app port
#$5 - sub path for data folder

#./update.exec.sh {APP_NAME} {VERSION_PREV} {VERSION_NEXT} {APP_PORT} {DATA_DIR}

./update.sh \
 centrifugo \
 v2.4.0 \
 v2.4.0 \
 8803 \
 /assets/app/