#!/bin/bash

#cadvisor

docker pull google/cadvisor
docker ps -aqf "name=cadvisor" | xargs -I'{}' docker stop $(docker ps -aqf "name=cadvisor")
docker ps -aqf "name=cadvisor" | xargs -I'{}' docker network disconnect --force dp-net {}
docker ps -aqf "name=cadvisor" | xargs -I'{}' docker rename cadvisor cadvisor.$(date +'%Y%d%m_%H%M%S').bak
netstat -ntpl | grep :9001
docker run --restart always -d \
 --name cadvisor \
 --hostname=dp-cadvisor \
 --network=dp-net \
 -p 9001:8080 \
 -e TZ="Europe/Moscow" \
 -v /:/rootfs:ro \
 -v /var/run:/var/run:rw \
 -v /sys:/sys:ro \
 -v /var/lib/docker/:/var/lib/docker:ro \
 -v /etc/localtime:/etc/localtime:ro \
 google/cadvisor
docker ps -aqf "name=cadvisor" --filter status=exited | xargs -I'{}' docker rm -v -f $(docker ps -aqf "name=cadvisor" --filter status=exited)
docker images -f dangling=true -q | xargs -I'{}' docker rmi $(docker images -f dangling=true -q)

echo Success