#!/bin/sh

xclip -h >/dev/null 2>&1 || sudo apt-get install xclip

SELECTION="clipboard"

help() {
  echo "Paste selections on shell"
  echo "  Usage $0 [options]"
  echo "    -c|--clip|--clipboard to clipboard (default)"
  echo "    -m|--middle to primary"
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
  -h|--help)
    help
    return 0
    ;;
esac

exec xclip -selection $SELECTION -o "$@"
