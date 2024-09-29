#!/bin/bash

set -e

NODE_VERSION="lts"
RUN="bash"

usage() {
  cat <<HELP_USAGE
  usage $0 [-v] [-h] path
    -v    version of node (actual: $NODE_VERSION)
    -h    print help
HELP_USAGE
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    -r|--run)
      shift
      RUN="node $1"
      ;;
    -v|--version)
      shift
      NODE_VERSION="$1"
      ;;
    -h|--help)
      usage
      ;;
    *)
      path="$1"
  esac
  shift
done

if [ -z "$path" ]; then
  echo "using pwd $(pwd)"
  path=$(pwd)
fi

path=$(realpath "$path")
name=$(basename "$path")
project=$name

echo "running $name > $project > $path on container golang:$GOLANG_VERSION"


PORTS=${PORTS}
if [ -n "$PORTS" ]; then
  PORTS="-p $PORTS"
fi

docker run \
  --rm \
  $PORTS \
  --name "$name" \
  -v "$path":"/app/$project" \
  -w "/app/$project" \
  -it "node:$NODE_VERSION" \
  $RUN
