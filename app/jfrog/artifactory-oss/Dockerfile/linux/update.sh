#!/bin/bash

#jfrog-artifactory-oss

# Params
#$1 - app name
#$2 - version prev
#$3 - version next
#$4 - app port
#$5 - sub path for data folder
#$6 - docker id

# Config
mkdir -p $5

docker pull $6/$1:$3
docker ps -aqf "name=$1_$2_$4" | xargs -I'{}' docker stop $(docker ps -aqf "name=$1_$2_$4")
docker ps -aqf "name=$1_$2_$4" | xargs -I'{}' docker network disconnect --force dp-net {}
docker ps -aqf "name=$1_$2_$4" | xargs -I'{}' docker rename $1_$2_$4 $1_$2_$4.$(date +'%Y%d%m_%H%M%S').bak
netstat -ntpl | grep :$4
docker run --restart always -d \
 --name $1_$3_$4 \
 --hostname=dp-$1_$3_$4 \
 --network=dp-net \
 -p $4:8081 \
 -p 8092:8082 \
 -e TZ="Europe/Moscow" \
 -v $5:/var/opt/jfrog/artifactory \
 -v /etc/timezone:/etc/timezone:ro \
 -v /etc/localtime:/etc/localtime:ro \
 $6/$1:$3
docker ps -aqf "name=$1_$2_$4" --filter status=exited | xargs -I'{}' docker rm -v -f $(docker ps -aqf "name=$1_$2_$4" --filter status=exited)
docker images -f dangling=true -q | xargs -I'{}' docker rmi $(docker images -f dangling=true -q)

echo Success