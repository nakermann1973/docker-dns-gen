#!/bin/bash

set -x
NAME="secure-dns-gen"

# Default value if var does not exist.
DOCKER_USER=${DOCKER_USER:-"abc"}

# latest
docker build -t "$DOCKER_USER/$NAME:latest" -t "$DOCKER_USER/$NAME:stable" -f Dockerfile .

# Find all builded container
CONTAINER_VERSION="$(docker image ls "$DOCKER_USER/$NAME" --format "{{.Tag}}")"



# Push hub.docker.com
if [[ ! -z "$DOCKER_PASS" ]] && [[ ! -z "$DOCKER_USER" ]]
then
    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
    for V in $CONTAINER_VERSION
    do
        docker push "$DOCKER_USER/$NAME:$V"
    done
fi


# Push github repo
if [[ ! -z "$GITHUB_PASS" ]] && [[ ! -z "$GITHUB_USER" ]]
then
    echo "$GITHUB_PASS" | docker login docker.pkg.github.com -u "$GITHUB_USER" --password-stdin
    for V in $CONTAINER_VERSION
    do
        docker tag "$DOCKER_USER/$NAME:$V" "docker.pkg.github.com/${{ github.repository }}/$NAME:$V"
        docker push "docker.pkg.github.com/${{ github.repository }}/$NAME:$V"
    done
fi
