#!/bin/bash

#python
#./builder_dev_version.sh
# Special version with a set of packages

echo USER: $USER.
echo HOSTNAME: $HOSTNAME.

uid="$1"
echo Docker hub uid: $uid.

version="$2"
echo Version python: $version.

version_alpine="$3"
if [ ! -z $version_alpine ]; then
  echo Version alpine: $version_alpine.
fi

docker pull python:$version
docker run -itd --name $uid-python-dev python:$version

docker exec $uid-python-dev sh -c \
 "apt-get update ; \
  apt-get install -y git curl zip unzip tzdata ca-certificates pip ; \
  exit"

docker commit $uid-python-dev $uid/python-dev

if [ ! -z $version_alpine ]; then
  docker pull python:$version-alpine$version_alpine
  docker run -itd --name $uid-python-alpine-dev python:$version-alpine$version_alpine

  docker exec $uid-python-alpine-dev sh -c \
   "apk update ; \
    apk add --no-cache git ; \
    apk add --no-cache curl ; \
    apk add --no-cache zip ; \
    apk add --no-cache unzip ; \
    apk add --no-cache tzdata ; \
    apk add --no-cache ca-certificates ; \
    pip install --upgrade pip ; \
    pip install pyTelegramBotAPI --user --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pushit ; \
    pip install telebot --user --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pushit ; \
    pip install requests --user --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pushit ; \
    pip install cx-Oracle==8.3.0 --user --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pushit ; \
    pip install matplotlib==3.7.3 --user --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pushit ; \
    pip install numpy==1.25.2 --user --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pushit ; \
    pip install openpyxl==3.1.2 --user --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pushit ; \
    pip install oracledb==1.4.1 --user --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pushit ; \
    pip install pandas==1.3.5 --user --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pushit ; \
    pip install Pillow==10.0.0 --user --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pushit ; \
    pip install SQLAlchemy==1.3.9 --user --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pushit ; \
    pip list ; \
    exit"

  docker commit $uid-python-alpine-dev $uid/python:alpine-dev
fi

if [ ! -z $uid ]; then
  docker login

  docker tag $uid/python-dev $uid/python:$version-dev
  docker push $uid/python:$version-dev

  docker stop $uid-python-dev
  docker rm -v -f $uid-python-dev
  docker rmi $uid/python:$version-dev
  docker rmi python:$version

  if [ ! -z $version_alpine ]; then
    docker tag $uid/python:alpine-dev $uid/python:$version-alpine$version_alpine-dev
    docker push $uid/python:$version-alpine$version_alpine-dev

    docker stop $uid-python-alpine-dev
    docker rm -v -f $uid-python-alpine-dev
    docker rmi $uid/python:$version-alpine$version_alpine-dev
    docker rmi python:$version-alpine$version_alpine
  fi

  docker logout
fi

echo Success