#!/bin/bash

set -e

path="$1"
if [ -z "$path" ]; then
	echo "using pwd $(pwd)"
	path=$(pwd)
fi

path=$(realpath "$path")
name=$(basename "$path")
project=$(echo "$path" | sed -e "s;^$GOPATH/;;")

echo "running $name > $project > $path on container"

docker run \
	--rm \
	--name "$name" \
	-v "$path":"/go/$project" \
	-w "/go/$project" \
	-it golang:latest
