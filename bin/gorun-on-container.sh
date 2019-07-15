#!/bin/bash

set -e

if [ -z "$1" ]; then
	echo "path of project is required"
	exit 1
fi

path=$(realpath "$1")
name=$(basename "$path")
project=$(echo "$path" | sed -e "s;^$GOPATH/;;")

echo "running $name > $project > $path on container"

docker run \
	--rm \
	--name "$name" \
	-v "$path":"/go/$project" \
	-w "/go/$project" \
	-it golang:latest \
	/bin/bash
