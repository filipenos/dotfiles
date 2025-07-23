#!/bin/bash

set -e

GOLANG_VERSION="latest"

if [ -f go.mod ]; then
  GOLANG_VERSION=$(cat go.mod | grep -E '^go\s[0-9]+\.[0-9]+(\.[0-9]+)?$' | sed 's/go //g')
fi

usage() {
  cat <<HELP_USAGE
  usage $0 [-b] [-v] [-h] path
    -b    build instead run
    -v    version of go (actual: $GOLANG_VERSION)
    -h    print help
HELP_USAGE
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    -b|--build)
      BUILD="1"
      ;;
    -v|--version)
      shift
      GOLANG_VERSION="$1"
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
project=$(echo "$path" | sed -e "s;^$GOPATH/;;")

echo "running $name > $project > $path on container golang:$GOLANG_VERSION"

PORTS=${PORTS}
if [ -n "$PORTS" ]; then
  PORTS="-p $PORTS"
fi

if [ ! -z $BUILD ]; then
  echo "building..."
  docker run \
    --rm \
    --name "$name" \
    -v "$path":"/go/$project" \
    -w "/go/$project" \
    -it "golang:$GOLANG_VERSION" \
    go build
else
  docker run \
    --rm \
    $PORTS \
    --name "$name" \
    --pull always \
    -v "$path":"/go/$project" \
    -w "/go/$project" \
    -it "golang:$GOLANG_VERSION"
fi


