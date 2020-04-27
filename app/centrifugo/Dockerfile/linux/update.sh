#!/bin/bash

#centrifugo

# Params
#$1 - app name
#$2 - version prev
#$3 - version next
#$4 - app port

# Config
mkdir -p /assets/app/$1/$4
cp ../../conf/config.json /assets/app/$1/$4

# Log and certs
mkdir -p /assets/instances/$1/$4/{log,certs}
chmod o+rw /assets/instances/$1/$4/log
chmod o+rw /assets/instances/$1/$4/certs

docker pull centrifugo/centrifugo:$3
docker ps -aqf "name=centrifugo_$2_$4" | xargs -I'{}' docker stop $(docker ps -aqf "name=centrifugo_$2_$4")
docker ps -aqf "name=centrifugo_$2_$4" | xargs -I'{}' docker network disconnect --force dp-net {}
docker ps -aqf "name=centrifugo_$2_$4" | xargs -I'{}' docker rename centrifugo_$2_$4 centrifugo_$2_$4.$(date +'%Y%d%m_%H%M%S').bak
netstat -ntpl | grep :$4
docker run --restart always -d \
 --name centrifugo_$3_$4 \
 --hostname=dp-centrifugo-$3-$4 \
 --network=dp-net \
 -p $4:8000 \
 -e TZ="Europe/Moscow" \
 -v /assets/app/$1/$4:/centrifugo \
 -v /assets/instances/$1/$4/log:/centrifugo/log \
 -v /assets/instances/$1/$4/certs:/centrifugo/certs \
 --ulimit nofile=65536:65536 \
 centrifugo/centrifugo:$3 centrifugo -c config.json
docker ps -aqf "name=centrifugo_$2_$4" --filter status=exited | xargs -I'{}' docker rm -v -f $(docker ps -aqf "name=centrifugo_$2_$4" --filter status=exited)
docker images -f dangling=true -q | xargs -I'{}' docker rmi $(docker images -f dangling=true -q)

echo Success