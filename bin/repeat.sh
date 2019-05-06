#!/bin/bash

if [ -z "$1" ]
then
	echo "command is required!"
	exit 1
fi

for d in $(ls -1); do
  eval $@ $d
done
