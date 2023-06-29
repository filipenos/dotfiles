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

projectname=$(basename $runpath)

echo "running $projectname path $runpath"

docker run \
  --rm \
  --interactive \
  --tty \
  --detach \
  --user "$(id -u):$(id -g)" \
  --name "$NAME" \
  --hostname "$NAME" \
  --publish 8080:8080 \
  --env "DOCKER_USER=$USER" \
  --volume "$runpath:/home/coder/$projectname" \
  --volume "$HOME/.config/code-server:/home/coder/.config/code-server" \
  --volume "$HOME/.local/share/code-server:/home/coder/.local/share/code-server" \
  codercom/code-server:latest

echo "visit: http://localhost:8080/?folder=/home/coder/$projectname"