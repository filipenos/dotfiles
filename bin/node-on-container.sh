#!/bin/bash

set -e

NODE_VERSION="lts"
RUN="${RUN:-bash}"

path=$(pwd)
path=$(realpath "$path")
project=$(basename "$path")

if [ -f package.json ]; then
  name=$(node -p "require('./package.json').name")
  main=$(node -p "require('./package.json').main")
else
  name=$project
fi

usage() {
  cat <<HELP_USAGE
  usage $0 [-r|-m] [-v] [-h]
  current: $name > $project > $path
    --run (-r)
      run npm script
    --main (-m)
      run main file (actual: $main)
    --node-modules-as-volume
      use node_modules as volume
    --install
      npm install before run
    --version (-v)
      version of node (actual: $NODE_VERSION)
    --help (-h)
      print help
HELP_USAGE
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    -r|-run|--run)
      shift
      RUN="npm run $1"
      ;;
    -m|-main|--main)
      shift
      RUN="node $1"
      ;;
    --node-modules-as-volume)
      NODE_MODULES_AS_VOLUME="1"
      ;;
    --install)
      NPM_INSTALL="1"
      ;;
    -v|-version|--version)
      shift
      NODE_VERSION="$1"
      ;;
    -h|-help|--help)
      usage
      ;;
  esac
  shift
done

PORTS=${PORTS}
if [ -n "$PORTS" ]; then
  PORTS="-p $PORTS"
fi

if [ ! -z $NODE_MODULES_AS_VOLUME ]; then
  echo "using node_modules as volume"
  VOLUMES="-v node_volumes:/app/$project/node_modules"
fi

if [ ! -z $NPM_INSTALL ]; then
  echo "npm install ..."
  docker run \
    --rm \
    --init \
    --name "$name" \
    -v "$path":"/app/$project" \
    $VOLUMES \
    -w "/app/$project" \
    -it "node:$NODE_VERSION" \
    npm install
fi

echo "running $name > $project > $path on container node:$NODE_VERSION"

docker run \
  --rm \
  --init \
  $PORTS \
  --name "$name" \
  -v "$path":"/app/$project" \
  $VOLUMES \
  -w "/app/$project" \
  -it "node:$NODE_VERSION" \
  $RUN
