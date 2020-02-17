#cadvisor

docker pull google/cadvisor
docker stop $(docker ps -aqf "name=cadvisor")
docker rename cadvisor cadvisor.$(date +'%Y%d%m_%H%M%S').bak
sudo docker run --restart always -d \
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
docker rm -v -f $(docker ps -aqf "name=cadvisor" --filter status=exited)
docker rmi $(docker images -f dangling=true -q)
