#!/bin/bash

if [ $# -le 1 ]; then
  echo "Usage $0 <name> <url> <desc> <group>"
  exit 1
fi

NAME=$(echo "$1.html" | tr '[:blank:]' '-')
URL="$2"
DESC="$3"
GROUP=$(echo "$4" | tr '[:blank:]' '-')

BASE_LINKS=$HOME/Links
if [ ! -d $BASE_LINKS ]; then
  mkdir $BASE_LINKS
  git -C $BASE_LINKS init --quiet
fi

FULLPATH="$BASE_LINKS"
if [ -f $GRUP ]; then
  FULLPATH="$FULLPATH/$GROUP"
  mkdir -p "$FULLPATH"
fi

FULLNAME="$FULLPATH/$NAME"
if [ -f $FULLNAME ]; then
  echo "Link $NAME already exists"
  exit 1
fi

STORE=$BASE_LINKS/links.csv
if [ ! -f $STORE ]; then
  echo "name,url,description,group" > $STORE
  git -C $BASE_LINKS add $STORE
  git -C $BASE_LINKS commit -m "\"Init links store\"" --quiet
fi

cat > $FULLNAME << EOF
<html>
<head>
<meta http-equiv="refresh" content="0; url=$URL" />
</head>
</html>
EOF

echo "\"$NAME\",\"$URL\",\"$DESC\",\"$GROUP\"" >> $STORE

git -C $BASE_LINKS add $FULLPATH/$NAME $STORE
git -C $BASE_LINKS commit -m "\"Add $NAME\"" --quiet
