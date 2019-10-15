#!/usr/bin/env sh
set -eu

: "${OPERATOR_TEST_STORAGE_CLASS:?}"
: "${DOCKER_IMAGE_REPOSITORY:?}"

export PATH=$PATH:$PWD/bin
export GOPATH=$PWD
export GO111MODULE=on
export TEST_NAMESPACE="test$(date +%s)"

# Random port to support parallelism with different webhook servers
export CF_OPERATOR_WEBHOOK_SERVICE_PORT=$(( ( RANDOM % 2000 )  + 2000 ))

echo "Running e2e tests in the ${ibmcloud_cluster} cluster."

echo "Creating namespace"
kubectl create namespace "$TEST_NAMESPACE"

echo "The cf-operator will be installed into the ${TEST_NAMESPACE} namespace."


echo "Running e2e tests with helm"
# fix SSL path
kube_path=$(dirname "$KUBECONFIG")
sed -i 's@certificate-authority: \(.*\)$@certificate-authority: '$kube_path'/\1@' $KUBECONFIG

echo "--------------------------------------------------------------------------------"
make -C src/code.cloudfoundry.org/cf-operator test-helm-e2e

echo "--------------------------------------------------------------------------------"
export TEST_NAMESPACE="test-storage$(date +%s)"
make -C src/code.cloudfoundry.org/cf-operator test-helm-e2e-storage
