# !/bin/bash

name="run-cloudbeaver"

if [ "$(docker ps -q -f name=$name)" ]; then
  read -p "alread running container $name stop this (yes|no): " yesno
  if [ "$yesno" = "yes" ]; then
    echo "stop container"
    docker stop $name
  fi
  exit 0
fi

path=$(pwd)
if [ -d "$1" ]; then
  path=$(realpath $1)
fi

docker run \
  --rm \
  --detach \
  --name "$name" \
  --publish 8978:8978 \
  -v $HOME/.cloudbeaver/workspace:/opt/cloudbeaver/workspace \
  dbeaver/cloudbeaver:latest
