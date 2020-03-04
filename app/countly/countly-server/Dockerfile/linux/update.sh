#!/bin/bash

#countly-server
docker volume create countly-server_data
docker volume inspect countly-server_data

docker pull countly/countly-server
docker stop $(docker ps -aqf "name=countly-server")
docker rename countly-server countly-server.$(date +'%Y%d%m_%H%M%S').bak
docker run --restart always -d \
 --name countly-server \
 --hostname=dp-countly-server \
 --network=dp-net \
 -p 8001:80 \
 -e TZ="Europe/Moscow" \
 -v countly-server_data:/var/lib/mongodb \
 -v /etc/localtime:/etc/localtime:ro \
 countly/countly-server:latest
docker rm -v -f $(docker ps -aqf "name=countly-server" --filter status=exited)
docker rmi $(docker images -f dangling=true -q)
