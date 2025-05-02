#!/bin/bash

NAME=run-open-webui

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
  -p 10434:8080 \
  --name $NAME \
  -e OLLAMA_BASE_URL=http://localhost:11434 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --restart always \
  --pull always \
  ghcr.io/open-webui/open-webui:main
