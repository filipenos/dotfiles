#!/bin/bash

NAME=run-sonarr
PORT=8989

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
  echo "  -m --tv change tv path"
  echo "  -d --downloads change download path"
  echo "  -h --help print this help"
  exit 0
}

base_path="$HOME/Volumes/$NAME"
config_path=$base_path/config
tv_path=$base_path/tv
downloads_path=$base_path/downloads

while [ $# -gt 0 ]; do
  case "$1" in
    -c|--config)
      config_path="$2"
      shift
      ;;
    -t|--tv)
      tv_path="$2"
      shift
      ;;
    -d|--downloads)
      downloads_path="$2"
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
  -e TZ=America/Sao_Paulo \
  -e UMASK_SET=022 `#optional` \
  -p $PORT:8989 \
  -v $config_path:/config \
  -v $tv:/tv \
  -v $downloads_path:/downloads \
  linuxserver/sonarr