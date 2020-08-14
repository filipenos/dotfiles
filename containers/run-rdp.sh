#!/bin/bash

NAME=run-rdp

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

printhelp() {
  echo "Usage $0"
  echo "  -c --config change config path"
  echo "  -h --help print this help"
  exit 0
}

base_path="$HOME/Volumes/$NAME"
config_path=$base_path/config

while [ $# -gt 0 ]; do
  case "$1" in
    -c|--config)
      config_path="$2"
      shift
      ;;
    -h|--help)
      printhelp
      ;;
  esac
  shift
done

docker run \
  --rm \
  --detach \
  --name=$NAME \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e TZ="America/Sao_Paulo" \
  -p 3389:3389 \
  -v /var/run/docker.sock:/var/run/docker.sock `#optional` \
  -v $config_path:/config \
  --shm-size="1gb" `#optional` \
  linuxserver/rdesktop