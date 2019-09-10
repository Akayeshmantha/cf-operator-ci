#!/bin/bash
set -ex

# Start Docker Daemon (and set a trap to stop it once this script is done)
echo 'DOCKER_OPTS="--data-root /scratch/docker --max-concurrent-downloads 10"' >/etc/default/docker
service docker start
service docker status
trap 'service docker stop' EXIT
sleep 10

# Login to the Docker registry.
echo "${DOCKER_TEAM_PASSWORD_RW}" | docker login "${DOCKER_REGISTRY}" --username "${DOCKER_TEAM_USERNAME}" --password-stdin

# Extract the fissile binary.
tar xvf s3.fissile-linux/fissile-*.tgz --directory "/usr/local/bin/"

# Pull the stemcell image.
stemcell_version="$(cat s3.stemcell-version/"${STEMCELL_VERSIONED_FILE##*/}")"
stemcell_image="${STEMCELL_REPOSITORY}:${stemcell_version}"
docker pull "${stemcell_image}"

if [ ! -e release/sha1 ]; then
  # Calculate sha1sum if the resource is a file from s3. bosh.io resources provide the checksum automatically
  SHA1=$(sha1sum release/*gz | cut -f1 -d ' ' )
else
  SHA1=$(cat release/sha1)
fi

# Build the releases.
tasks_dir="$(dirname $0)"
bash <(yq -r ".manifest_version as \$cf_version | .releases[] | \"source ${tasks_dir}/build_release.sh; build_release \\(\$cf_version|@sh) '${DOCKER_REGISTRY}' '${DOCKER_ORGANIZATION}' '${DOCKER_TEAM_USERNAME}' '${DOCKER_TEAM_PASSWORD_RW}' '${STEMCELL_OS}' '${stemcell_version}' '${stemcell_image}' \\(.name|@sh) \\(.url|@sh) \\(.version|@sh) \\(.sha1|@sh)\"" "${BUILDPACK_NAME}")
