#!/bin/bash

NAME=run-sunshine

if [ "$(docker ps -q -f name=$NAME)" ]; then
  read -p "alread running container $NAME, stop this (yes|no): "  yesno
  if [ "$yesno" = "yes" ]; then
    echo "stop container"
    docker stop $NAME
  elif [ "$yesno" = "con" ]; then
    echo conecting to container
    docker exec -it $NAME /bin/bash
  fi
  exit 0
fi

docker run \
  --rm \
  --detach \
  --device /dev/dri/ \
  --name=$NAME \
  --ipc=host \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e TZ=America/Sao_Paulo \
  -v run-sunshine:/config \
  -p 47984-47990:47984-47990/tcp \
  -p 48010:48010 \
  -p 47998-48000:47998-48000/udp \
  lizardbyte/sunshine:master-ubuntu-24.04