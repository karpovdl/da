#!/bin/bash

#matomo
docker volume create matomo_data
docker volume inspect matomo_data

docker pull matomo
docker stop $(docker ps -aqf "name=matomo")
docker rename matomo matomo.$(date +'%Y%d%m_%H%M%S').bak
docker run --restart always -d \
 --name matomo \
 --hostname=dp-matomo \
 --network=dp-net \
 -p 8002:80 \
 -v matomo_data:/var/www/html \
 -e TZ="Europe/Moscow" \
 -v /etc/localtime:/etc/localtime:ro \
 matomo
docker rm -v -f $(docker ps -aqf "name=matomo" --filter status=exited)
docker rmi $(docker images -f dangling=true -q)
