# !/bin/bash

name="run-pgadmin"

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

docker run \
  --rm \
  --detach \
  --name "$name" \
  --publish 8090:80 \
  -e "PGADMIN_DEFAULT_EMAIL=filipenos@gmail.com" \
  -e "PGADMIN_DEFAULT_PASSWORD=filipe" \
  -v "pgadmin-data:/var/lib/pgadmin" \
  dpage/pgadmin4:latest
