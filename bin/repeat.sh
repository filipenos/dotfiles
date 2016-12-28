#!/bin/bash

if [ -z "$1" ]
then
	echo "command is required!"
	exit 1
fi

echo "exucuting ${*:1}"

while true
do
	${*:1}
	sleep 1
done
