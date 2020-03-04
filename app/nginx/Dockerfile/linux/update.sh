#!/bin/bash

#nginx

docker pull nginx
docker stop $(docker ps -aqf "name=nginx")
docker rename nginx nginx.$(date +'%Y%d%m_%H%M%S').bak
docker run --restart always -d \
 --name nginx \
 --hostname=dp-nginx \
 --network=dp-net \
 -p 443:443 \
 -p 80:80 \
 -e TZ="Europe/Moscow" \
 -v /assets/nginx/nginx_data/nginx.conf:/etc/nginx/nginx.conf:ro \
 -v /assets/nginx/nginx_data/conf.d/:/etc/nginx/conf.d/:ro \
 -v /assets/nginx/nginx_data/ssl:/etc/nginx/ssl:ro \
 -v /assets/nginx/nginx_log:/var/log/nginx \
 -v /etc/localtime:/etc/localtime:ro \
 nginx
docker rm -v -f $(docker ps -aqf "name=nginx" --filter status=exited)
docker rmi $(docker images -f dangling=true -q)
