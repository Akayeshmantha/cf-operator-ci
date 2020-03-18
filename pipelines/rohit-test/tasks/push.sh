#!/bin/bash

set -e

ls
export GIT_ASKPASS=../ci/pipelines/rohit-test/tasks/git-password.sh

pushd src/

git config --global user.name "CFContainerizationBot"
git config --global user.email "cf-containerization@cloudfoundry.org@cloudfoundry.org"
git config --global credential.helper cache
git config core.sshCommand 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
git config --global core.editor "cat"

git checkout -b rohit/bdpl

git config credential.https://github.com.username CFContainerizationBot

git push -f origin rohit/bdpl
popd
