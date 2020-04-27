#!/bin/bash

NAME=transmission

if [ "$(docker ps -q -f name=$NAME)" ]; then
  read -p "alread running container $NAME, stop this (yes|no): "  yesno
  if [ "$yesno" = "yes" ]; then
    echo "stop container"
    docker stop $NAME
  fi
  exit 0
fi

base_path=$(dirname $(realpath $0))
config_path=$base_path/transmission-config
downloads_path=$base_path/transmission-downloads
watch_path=$base_path/transmission-watch

while [ $# -gt 0 ]
do
  case "$1" in
    -c|--config)
      config_path="$2"
      shift
      ;;
    -d|--downloads)
      downloads_path="$2"
      shift
      ;;
    -w|--watch)
      watch_path="$2"
      shift
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
  -e TRANSMISSION_WEB_HOME=/combustion-release/ \
  -e USER=filipe \
  -e PASS=filipe \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v $config_path:/config \
  -v $downloads_path:/downloads \
  -v $watch_path:/watch \
  linuxserver/transmission

  #--restart unless-stopped \