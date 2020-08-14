#!/bin/bash

NAME=run-plex

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
  echo "  -m --media change media path"
  echo "  -t --transcode change transcode path"
  echo "  -h --help print this help"
  exit 0
}

base_path="$HOME/Volumes/$NAME"
config_path=$base_path/config
media_path=$base_path/media
transcode_path=$base_path/transcode
plex_claim=""

while [ $# -gt 0 ]; do
  case "$1" in
    -c|--config)
      config_path="$2"
      shift
      ;;
    -m|--media)
      media_path="$2"
      shift
      ;;
    -t|--transcode)
      transcode_path="$2"
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

#TODO (filipenos) ao ler do prompt tem um erro de leitura de variavel, o read por padrao adiciona uma nova linha ao final
#https://www.computerhope.com/unix/bash/read.htm
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
  --name $NAME \
  -p 32400:32400/tcp \
  -p 3005:3005/tcp \
  -p 8324:8324/tcp \
  -p 32469:32469/tcp \
  -p 1900:1900/udp \
  -p 32410:32410/udp \
  -p 32412:32412/udp \
  -p 32413:32413/udp \
  -p 32414:32414/udp \
  -e TZ="America/Sao_Paulo" \
  -e PLEX_CLAIM="$plex_claim" \
  -h $NAME \
  -v $config_path:/config \
  -v $transcode_path:/transcode \
  -v $media_path:/data \
  plexinc/pms-docker