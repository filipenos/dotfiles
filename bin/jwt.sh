#!/bin/bash

# cat /dev/stdin

cat - | awk -F'.' '{print $2}' | base64 -d