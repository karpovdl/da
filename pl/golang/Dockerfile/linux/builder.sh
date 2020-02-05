#!/bin/bash

#golang
#./builder.sh

echo USER: $USER.
echo HOSTNAME: $HOSTNAME.

uid="$1"
echo Docker hub uid: $uid.

version="$2"
echo Version golang: $version.

version_alpine="$3"
if [ ! -z $version_alpine ]; then
  echo Version alpine: $version_alpine.
fi

docker pull golang:$version
docker run -itd --name $uid-golang golang:$version

docker exec $uid-golang sh -c \
 "apt-get update ; \
  apt-get install -y git curl zip unzip tzdata ca-certificates ; \
  exit"

docker commit $uid-golang $uid/golang

if [ ! -z $version_alpine ]; then
  docker pull golang:$version-alpine$version_alpine
  docker run -itd --name $uid-golang-alpine golang:$version-alpine$version_alpine

  docker exec $uid-golang-alpine sh -c \
   "apk update ; \
    apk add --no-cache git ; \
    apk add --no-cache curl ; \
    apk add --no-cache zip ; \
    apk add --no-cache unzip ; \
    apk add --no-cache tzdata ; \
    apk add --no-cache ca-certificates ; \
    exit"

  docker commit $uid-golang-alpine $uid/golang:alpine
fi

docker login

docker tag $uid/golang $uid/golang:$version
docker push $uid/golang:$version

docker tag $uid/golang $uid/golang
docker push $uid/golang

docker stop $uid-golang
docker rm -v -f $uid-golang
docker rmi $uid/golang:$version
docker rmi $uid/golang:latest
docker rmi golang:$version

if [ ! -z $version_alpine ]; then
  docker tag $uid/golang:alpine $uid/golang:$version-alpine$version_alpine
  docker push $uid/golang:$version-alpine$version_alpine

  docker tag $uid/golang:alpine $uid/golang:alpine
  docker push $uid/golang:alpine

  docker stop $uid-golang-alpine
  docker rm -v -f $uid-golang-alpine
  docker rmi $uid/golang:$version-alpine$version_alpine
  docker rmi $uid/golang:alpine
  docker rmi golang:$version-alpine$version_alpine
fi

docker logout