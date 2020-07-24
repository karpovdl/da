#!/bin/bash

#Install
#./install.sh

sudo ./install_go.sh go1.14.6.linux-amd64.tar.gz

echo GOROOT = "$GOROOT"
echo GOPATH = "$GOPATH"
echo PATH = "$PATH"

go version
#go env

echo Success all