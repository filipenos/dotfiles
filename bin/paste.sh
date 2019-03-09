#!/bin/sh

xclip -h >/dev/null 2>&1 || sudo apt-get install xclip

SELECTION="clipboard"
FILE=

help() {
  echo "Paste selections on shell"
  echo "  Usage $0 [options]"
  echo "    -c|--clip|--clipboard to clipboard (default)"
  echo "    -m|--middle to primary"
  echo "    -f|--file file to output"
  echo "    -h|--help to print this message"
}

case "$1" in
  -c|--clip|--clipboard)
    shift
    SELECTION="clipboard"
    ;;
  -m|--middle)
    shift
    SELECTION="primary"
    ;;
  -f|--file)
    shift
    FILE="$1"
    ;;
  -h|--help)
    help
    return 0
    ;;
esac

if [ -n "$FILE" ]; then
  exec xclip -selection $SELECTION -o "$@" > "$FILE"
else
  exec xclip -selection $SELECTION -o "$@"
fi
