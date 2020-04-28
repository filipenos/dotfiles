#!/bin/bash

NAME=run-radarr
PORT=7878

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
  echo "  -d --downloads change download path"
  echo "  -m --movies change movies path"
  echo "  -h --help print this help"
  exit 0
}

base_path="$HOME/Volumes/$NAME"
config_path=$base_path/config
movies_path=$base_path/movies
downloads_path=$base_path/downloads

while [ $# -gt 0 ]; do
  case "$1" in
    -c|--config)
      config_path="$2"
      shift
      ;;
    -m|--movies)
      movies_path="$2"
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
  -p $PORT:7878 \
  -v $config_path:/config \
  -v $movies_path:/movies \
  -v $downloads_path:/downloads \
  linuxserver/radarr