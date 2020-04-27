#!/bin/bash

#Restart docker
#./restart.sh

./info.sh

systemctl stop docker
service docker

if [[ $1 == "rm_net_files" ]] then
  rm -rf /var/lib/docker/network/files
fi

systemctl start docker

echo Success
