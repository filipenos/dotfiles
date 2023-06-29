#!/bin/bash

set -e

IMAGE=alpine
CMD=/bin/sh

path=$(pwd)
name=$(basename $path)
mount="/mnt/$name"

case "$1" in
  -h|--help)
    echo "usage $0 image_name command with args (default run: alpine /bin/sh)"
    exit 0
    ;;
esac

if [ $# -eq 1 ]; then
  IMAGE=$1
elif [ $# -gt 1 ]; then
  IMAGE=$1
  shift
  CMD=$@
fi

docker run \
  --rm \
  --publish 18080:8080 \
  --name "$name" \
  -v "$(pwd)":"$mount" \
  -w "$mount" \
  -it $IMAGE $CMD
