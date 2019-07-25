#!/bin/bash

set -e

GOLANG_VERSION="latest"

while [ $# -gt 0 ]; do
  case "$1" in
    -b|--build)
      BUILD="1"
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

echo "running $name > $project > $path on container"

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
    --name "$name" \
    -v "$path":"/go/$project" \
    -w "/go/$project" \
    -it "golang:$GOLANG_VERSION"
fi


