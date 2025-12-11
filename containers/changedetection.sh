#!/bin/bash

NAME=run-changedetection

if [ "$(docker ps -q -f name=$NAME)" ]; then
  read -p "alread running container $NAME, stop this (yes|no|logs): " yesno
  if [ "$yesno" = "yes" ]; then
    echo "stop container"
    docker stop $NAME
    docker rm -f $NAME
  elif [ "$yesno" = "logs" ]; then
    echo "showing logs for container $NAME"
    docker logs --follow $NAME
  fi
  exit 0
fi

docker run \
  -d \
  --restart always \
  -p "127.0.0.1:5000:5000" \
  -v changedetection:/datastore \
  --name $NAME \
  dgtlmoon/changedetection.io

#docker pull dgtlmoon/changedetection.io
#docker kill $(docker ps -a -f name=changedetection.io -q)
#docker rm $(docker ps -a -f name=changedetection.io -q)

