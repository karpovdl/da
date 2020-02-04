#!/bin/bash

#alpine
#./builder.sh

echo USER: $USER.
echo HOSTNAME: $HOSTNAME.

uid="$1"
echo Docker hub uid: $uid.

version="$2"
echo Version: $version.

docker pull alpine:$version
docker run -itd --name $uid-alpine alpine:$version

docker exec $uid-alpine sh -c \
 "apk update ; \
  apk add --no-cache git ; \
  apk add --no-cache curl ; \
  apk add --no-cache zip ; \
  apk add --no-cache unzip ; \
  apk add --no-cache tzdata ; \
  apk add --no-cache ca-certificates ; \
  exit"

docker commit $uid-alpine $uid/alpine

docker login

docker tag $uid/alpine $uid/alpine:$version
docker push $uid/alpine:$version

docker tag $uid/alpine $uid/alpine
docker push $uid/alpine

docker stop $uid-alpine
docker rm -v -f $uid-alpine
docker rmi $uid/alpine:$version
docker rmi $uid/alpine:latest
docker rmi alpine:$version

docker logout