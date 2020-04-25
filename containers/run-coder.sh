#!/bin/bash

NAME=run-coder

if [ "$(docker ps -q -f name=$NAME)" ]; then
  read -p "alread running container $NAME, stop this (yes|no): "  yesno
  if [ "$yesno" = "yes" ]; then
    echo "stop container"
    docker stop $NAME
  fi
  exit 0
fi

if [ -d "$1" ]; then
  runpath=$(realpath $1)
else
  runpath=$(pwd)
fi

echo "running $NAME on path $runpath"

docker run \
  --rm \
  --interactive \
  --tty \
  --detach \
  --user "$(id -u):$(id -g)" \
  --name "$NAME" \
  --hostname "$NAME" \
  --publish 8080:8080 \
  --env PASSWORD=filipe \
  --volume "/etc/passwd:/etc/passwd:ro" \
  --volume "/home/filipe:/home/filipe" \
  --volume "/home/linuxbrew:/home/linuxbrew" \
  --volume "$runpath:/home/filipe/project" \
  codercom/code-server