#portainer
docker volume create portainer_data
docker volume inspect portainer_data

docker pull portainer/portainer:latest
docker stop $(docker ps -aqf "name=portainer")
docker rename portainer portainer.$(date +'%Y%d%m_%H%M%S').bak
docker run --restart always -d \
 --name portainer \
 --hostname=dp-portainer \
 --network=dp-net \
 -p 9000:9000 \
 -e TZ="Europe/Moscow" \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v portainer_data:/data \
 -v /etc/timezone:/etc/timezone:ro \
 -v /etc/localtime:/etc/localtime:ro \
 portainer/portainer:latest
docker rm -v -f $(docker ps -aqf "name=portainer" --filter status=exited)
docker rmi $(docker images -f dangling=true -q)