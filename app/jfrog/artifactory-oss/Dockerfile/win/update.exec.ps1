#power shell

#.\update.exec.ps1
#powershell -noexit "& "".\update.exec.ps1"""

#$1 - app name
#$2 - version application prev
#$3 - version application next
#$4 - app port
#$5 - app port ui
#$6 - sub path for data folder
#$7 - docker id

#.\update.ps1 {APP_NAME} {VERSION_PREV} {VERSION_NEXT} {APP_PORT} {APP_PORT_UI} {DATA_DIR} {DockerID}

powershell -noexit "& "".\update.ps1 jfrog-artifactory-oss 7.4.3 7.4.3 8081 8082 jfrog/artifactory-oss karpovdl"""
