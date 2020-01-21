#!/bin/sh

SELECTION="clipboard"

help() {
  echo "Copy selections of shell"
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

test $(uname -s) = "Darwin"
if [ $? -eq 0 ]; then
  exec pbcopy "$@"
else
  xclip -h >/dev/null 2>&1 || sudo apt-get install xclip
  exec xclip -selection $SELECTION -i "$@"
fi
