#!/bin/bash

# -f param ssh run on background
# -N do not execute a remote command

host=${@: -1}
ports=""

for p in "${@:1:$#-1}"
do
  ports="$ports -L $p:localhost:$p"
done

ssh -N $ports $host
