#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage $0 name url"
  exit 1
fi

DIR=$HOME/Links
if [ ! -d $DIR ];then
  mkdir $DIR
  git -C $DIR init
fi

NAME=$(echo "$1.html" | tr '[:blank:]' '-')
URL=$2

cat > "$DIR/$NAME" << EOF
<html>
<head>
<meta http-equiv="refresh" content="0; url=$URL" />
</head>
</html>
EOF

git -C $DIR add $NAME
git -C $DIR commit -m "Add $NAME"
