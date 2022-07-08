#!/bin/bash

if [ -z $1 ]; then
  echo "show all ports"
  lsof -i -P -n | grep 'LISTEN\|COMMAND'
else
  echo "show port $1"
  lsof -i:$1
fi

