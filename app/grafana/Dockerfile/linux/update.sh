#!/bin/bash

#grafana
docker volume create grafana_storage
docker volume inspect grafana_storage

docker pull grafana/grafana
docker stop $(docker ps -aqf "name=grafana")
docker rename grafana grafana.$(date +'%Y%d%m_%H%M%S').bak
docker run --restart always -d --name grafana \
 --hostname=dp-grafana \
 --network=dp-net \
 -p 8030:3000 \
 -v grafana_storage:/var/lib/grafana \
 -e TZ="Europe/Moscow" \
 -v /etc/localtime:/etc/localtime:ro \
 grafana/grafana
docker rm -v -f $(docker ps -aqf "name=grafana" --filter status=exited)
docker rmi $(docker images -f dangling=true -q)
