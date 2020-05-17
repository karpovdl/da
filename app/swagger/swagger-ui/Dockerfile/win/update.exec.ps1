#power shell

#.\update.exec.ps1
#powershell -noexit "& "".\update.exec.ps1"""

#$1 - app name
#$2 - version application prev
#$3 - version application next
#$4 - app port
#$5 - sub path for data folder

#.\update.ps1 {APP_NAME} {VERSION_PREV} {VERSION_NEXT} {APP_PORT} {DATA_DIR}
# $1\$5 - {APP_NAME}\{DATA_DIR}

powershell -noexit "& "".\update.ps1 swagger-ui v3.25.3 v3.25.3 8004 swagger/json8004"""
