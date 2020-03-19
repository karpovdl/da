#!/bin/bash

#Install golang Ubuntu
#./install_go.sh

file="$1"
echo Golang source = $file

if [[ $file != "" ]]; then
  sudo apt-get purge golang*
  sudo wget https://dl.google.com/go/$file
  sudo tar -xvf $file
  sudo rm -rf /usr/local/go
  sudo mv go /usr/local
  export GOROOT=/usr/local/go
  echo GOROOT = "${GOROOT}"
  export GOPATH=$HOME/go
  echo GOPATH = "${GOPATH}"
  export PATH="${PATH}:${GOROOT}/bin:${GOPATH}"
  echo PATH = "${PATH}"

  go version
  go env
else
  echo None install
fi

if [ -f $file ]; then
  rm $file
fi

echo Success