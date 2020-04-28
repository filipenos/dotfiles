#!/bin/bash

NAME=run-transmission

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
  echo "  -w --watch change watch path"
  echo "  -h --help print this help"
  exit 0
}

base_path="$HOME/Volumes/$NAME"
config_path=$base_path/config
downloads_path=$base_path/downloads
watch_path=$base_path/watch
interface="/transmission-web-control/" #/combustion-release/, /transmission-web-control/, /kettu/

while [ $# -gt 0 ]; do
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
  -e TRANSMISSION_WEB_HOME=$interface \
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