#!/bin/bash

port=8080
if [ ! -z $1 ]; then
	port=$1
fi

echo "exporting $port to web"

ssh -R 80:localhost:$port ssh.localhost.run
