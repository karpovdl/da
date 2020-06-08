#!/bin/bash

#Change gopath
#./gopath.sh

export GOROOT=/usr/local/go
echo GOROOT = "$GOROOT"
export GOPATH=$HOME/go
echo GOPATH = "$GOPATH"
export PATH="$PATH:$GOROOT/bin:$GOPATH"
echo PATH = "$PATH"

go version

echo Success