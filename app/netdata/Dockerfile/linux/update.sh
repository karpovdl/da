#!/bin/bash

#netdata

docker pull netdata/netdata
docker ps -aqf "name=netdata" | xargs -I'{}' docker stop $(docker ps -aqf "name=netdata")
docker ps -aqf "name=netdata" | xargs -I'{}' docker network disconnect --force dp-net {}
docker ps -aqf "name=netdata" | xargs -I'{}' docker rename netdata netdata.$(date +'%Y%d%m_%H%M%S').bak
netstat -ntpl | grep :9003
docker run --restart always -d \
 --name netdata \
 --hostname=dp-netdata \
 --network=dp-net \
 -p 9003:19999 \
 -e TZ="Europe/Moscow" \
 -v /proc:/host/proc:ro \
 -v /sys:/host/sys:ro \
 -v /var/run/docker.sock:/var/run/docker.sock:ro \
 --cap-add SYS_PTRACE \
 --security-opt apparmor=unconfined \
 netdata/netdata
docker ps -aqf "name=netdata" --filter status=exited | xargs -I'{}' docker rm -v -f $(docker ps -aqf "name=netdata" --filter status=exited)
docker images -f dangling=true -q | xargs -I'{}' docker rmi $(docker images -f dangling=true -q)

echo Success