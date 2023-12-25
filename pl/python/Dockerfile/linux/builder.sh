#!/bin/bash

#python
#./builder.sh

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
docker run -itd --name $uid-python python:$version

docker exec $uid-python sh -c \
 "apt-get update ; \
  apt-get install -y git curl zip unzip tzdata ca-certificates pip ; \
  exit"

docker commit $uid-python $uid/python

if [ ! -z $version_alpine ]; then
  docker pull python:$version-alpine$version_alpine
  docker run -itd --name $uid-python-alpine python:$version-alpine$version_alpine

  docker exec $uid-python-alpine sh -c \
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
    pip list ; \
    exit"

  docker commit $uid-python-alpine $uid/python:alpine
fi

if [ ! -z $uid ]; then
  docker login

  docker tag $uid/python $uid/python:$version
  docker push $uid/python:$version

  docker tag $uid/python $uid/python
  docker push $uid/python

  docker stop $uid-python
  docker rm -v -f $uid-python
  docker rmi $uid/python:$version
  docker rmi $uid/python:latest
  docker rmi python:$version

  if [ ! -z $version_alpine ]; then
    docker tag $uid/python:alpine $uid/python:$version-alpine$version_alpine
    docker push $uid/python:$version-alpine$version_alpine

    docker tag $uid/python:alpine $uid/python:alpine
    docker push $uid/python:alpine

    docker stop $uid-python-alpine
    docker rm -v -f $uid-python-alpine
    docker rmi $uid/python:$version-alpine$version_alpine
    docker rmi $uid/python:alpine
    docker rmi python:$version-alpine$version_alpine
  fi

  docker logout
fi

echo Success