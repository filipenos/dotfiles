# !/bin/bash

name="run-cloudbeaver"

if [ "$(docker ps -q -f name=$name)" ]; then
  read -p "alread running container $name stop this (yes|no): " yesno
  if [ "$yesno" = "yes" ]; then
    echo "stop container"
    docker stop $name
  fi
  exit 0
fi

path=$(pwd)
if [ -d "$1" ]; then
  path=$(realpath $1)
fi

export CB_LOCAL_HOST_ADDR=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)

docker run \
  --rm \
  --detach \
  --name "$name" \
  --publish 8978:8978 \
  --add-host=host.docker.internal:${CB_LOCAL_HOST_ADDR} \
  -v $HOME/.cloudbeaver/workspace:/opt/cloudbeaver/workspace \
  dbeaver/cloudbeaver:latest
