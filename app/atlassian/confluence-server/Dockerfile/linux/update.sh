#!/bin/bash

#confluence-server
docker volume create confluence-server_data
docker volume inspect confluence-server_data

docker pull atlassian/confluence-server
docker stop $(docker ps -aqf "name=confluence-server")
docker rename confluence-server confluence-server.$(date +'%Y%d%m_%H%M%S').bak
docker run --restart always -d \
 --name confluence-server \
 --hostname=dp-confluence-server \
 --network=dp-net \
 -p 8090:8090 \
 -p 8091:8091 \
 -e TZ="Europe/Moscow" \
 -v confluence-server_data:/var/atlassian/application-data/confluence \
 -v /etc/localtime:/etc/localtime:ro \
 atlassian/confluence-server
docker rm -v -f $(docker ps -aqf "name=confluence-server" --filter status=exited)
docker rmi $(docker images -f dangling=true -q)
