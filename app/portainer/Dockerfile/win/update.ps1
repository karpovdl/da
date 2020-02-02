#portainer

docker volume create portainer_data
docker volume inspect portainer_data

docker pull portainer/portainer:latest
docker stop $(docker ps -aqf "name=portainer")
$dt = Get-Date -format "yyyMMdd_HHmmss"
docker rename portainer portainer.$($dt).bak
docker run --restart always -d `
 --name portainer `
 --hostname=dp-portainer `
 --network=dp-net `
 -p 9000:9000 `
 -e TZ="Europe/Moscow" `
 -v /var/run/docker.sock:/var/run/docker.sock `
 -v portainer_data:/data `
 portainer/portainer:latest
docker rm -v -f $(docker ps -aqf "name=portainer" --filter status=exited)
#docker rmi $(docker images -f dangling=true -q)