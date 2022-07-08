#!/bin/bash

set -e

IMAGE="alpine"
CMD="/bin/sh"

path=$(pwd)
name=$(basename "$path")

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
  --name "$name" \
  -v "$(pwd)":"/mnt" \
  -w "/mnt" \
  -it "$IMAGE" "$CMD"
