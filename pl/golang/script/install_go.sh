#!/bin/bash

#Install golang Ubuntu
#./install_go.sh

file="$1"
echo Golang source = $file

if [[ $file != "" ]]; then
  apt-get purge golang*
  wget https://dl.google.com/go/$file
  tar -xvf $file
  rm -rf /usr/local/go
  mv go /usr/local
  export GOROOT=/usr/local/go
  echo GOROOT = "$GOROOT"
  export GOPATH=$HOME/go
  echo GOPATH = "$GOPATH"
  export PATH="$PATH:$GOROOT/bin:$GOPATH"
  echo PATH = "$PATH"

  go version
  #go env
else
  echo None install
fi

if [ -f $file ]; then
  rm $file
fi

echo Success