#!/bin/bash

# TODO Add suport to params
# rename repeat.sh to repeat
# -quant quant of repeats, default is infinite
# -clear if clear after run command

quant=
clean=

while [ "$1" != "" ]; do
	case $1 in
		-q | --quant)
      shift
      quant=$1
      ;;
		-c | --clean)
      shift
      clean=$1
      ;;
    -h | --help)
      help
      ;;
  esac
done

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
