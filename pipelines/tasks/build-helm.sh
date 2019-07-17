#!/usr/bin/env sh
set -ex

export PATH=$PATH:$PWD/bin
export GOPATH=$PWD

set -ex
make -C src/code.cloudfoundry.org/cf-operator build-helm
cp src/code.cloudfoundry.org/cf-operator/helm/cf-operator*.tgz helm-charts/
