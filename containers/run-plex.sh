#!/bin/bash

NAME=run-plex
PORT=32400

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
  echo "  -claim --plex_claim set plex claim get on https://www.plex.tv/claim"
  echo "  -c --config change config path"
  echo "  -m --movies change movies path"
  echo "  -t --tv change tv path"
  echo "  -h --help print this help"
  exit 0
}

base_path="$HOME/Volumes/$NAME"
config_path=$base_path/config
movies_path=$base_path/movies
tv_path=$base_path/tv
plex_claim=""

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
    -t|--tv)
      tv_path="$2"
      shift
      ;;
    -claim|--plex_claim)
      plex_claim="$2"
      shift
      ;;
    -h|--help)
      printhelp
      ;;
  esac
  shift
done

if [ -z "$plex_claim" ]; then
  read -p "Claim server: get on https://www.plex.tv/claim " plex_claim
fi

if [ -z "$plex_claim" ]; then
  echo invalid plex claim
  exit 1
fi

docker run \
  --rm \
  --detach \
  --name=$NAME \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e VERSION=docker \
  -e PLEX_CLAIM=$plex_claim \
  -p $PORT:32400 \
  -p $PORT:32400/udp \
  -p 32469:32469 \
  -p 32469:32469/udp \
  -p 1900:1900/udp \
  -v $config_path:/config \
  -v $tv_path:/tv \
  -v $movies_path:/movies \
  linuxserver/plex

#--restart unless-stopped \