#!/usr/bin/env sh
set -ex

export PATH=$PATH:$PWD/bin
export GOPATH=$PWD
export GO111MODULE=on

echo "In task A....."
echo "I GOT THE LOCK!"

sleep 60

exit 0