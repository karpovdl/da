#!/bin/bash

#mysql
docker volume create matomo-mysql_data
docker volume inspect matomo-mysql_data

docker pull mysql
docker stop $(docker ps -aqf "name=matomo-mysql")
docker rename matomo-mysql matomo-mysql.$(date +'%Y%d%m_%H%M%S').bak
sudo docker run --restart always -d \
 --name matomo-mysql \
 --hostname=dp-matomo-mysql \
 --network=dp-net \
 -p 8003:3306 \
 -p 8004:33060 \
 -e MYSQL_ROOT_PASSWORD="1111" \
 -v matomo-mysql_data:/var/lib/mysql \
 -e TZ="Europe/Moscow" \
 -v /etc/localtime:/etc/localtime:ro \
 mysql
docker rm -v -f $(docker ps -aqf "name=matomo-mysql" --filter status=exited)
docker rmi $(docker images -f dangling=true -q)
