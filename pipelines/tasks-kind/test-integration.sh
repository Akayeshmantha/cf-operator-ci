#!/usr/bin/env sh
set -eu

# Download and install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && mv kubectl /usr/local/bin/

# Download and install KinD
GO111MODULE=on go get sigs.k8s.io/kind

# It's possible to download and install KinD using curl, similar as for kubectl
# This is useful in cases when Go toolchain isn't available or you prefer running stable version
# Binaries for KinD are available on GitHub Releases: https://github.com/kubernetes-sigs/kind/releases
# - curl -Lo kind https://github.com/kubernetes-sigs/kind/releases/download/0.0.1/kind-linux-amd64 && chmod +x kind && sudo mv kind /usr/local/bin/

# Create a new Kubernetes cluster using KinD
kind create cluster

# Set KUBECONFIG environment variable
export KUBECONFIG="$(kind get kubeconfig-path)"
export USE_KIND="true"

# Set CF-OPERATER Docker Image Tag
export DOCKER_IMAGE_TAG="v0.4.2-0.g604925f0"
# For PersistOutput container command

docker pull docker.io/cfcontainerization/cf-operator:v0.4.2-0.g604925f0
kind load docker-image docker.io/cfcontainerization/cf-operator:v0.4.2-0.g604925f0

# Download and install helm
curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
# yes, heredocs are broken in before_script: https://travis-ci.community/t/multiline-commands-have-two-spaces-in-front-breaks-heredocs/2756

kubectl create -f tiller.yml
helm init --service-account tiller --wait

echo "--------------------------------------------------------------------------------"
echo "Running integration tests"
make -C src/code.cloudfoundry.org/cf-operator test-integration

echo "--------------------------------------------------------------------------------"
echo "Running integration storage tests"
make -C src/code.cloudfoundry.org/cf-operator test-integration-storage
