#!/bin/sh

test $(uname -s) = "Darwin"
if [ $? -eq 0 ]; then
  SELECTION="general"
  PC=mac
elif [ $(grep -q "microsoft" /proc/sys/kernel/osrelease ; echo $?) -eq 0 ]; then
  PC=wsl
else
  SELECTION="clipboard"
  PC=linux
fi

help() {
  echo "Copy selections of shell"
  echo "  Usage $0 [options]"
  echo "    -c|--clip|--clipboard to clipboard (default)"
  echo "    -m|--middle to primary"
  echo "    -h|--help to print this message"
}

copy() {
  if [ $PC = "mac" ]; then #-pboard {general | ruler | find | font}
    exec pbcopy -pboard $SELECTION "$@"
  elif [ $PC = "wsl" ]; then
    exec powershell.exe -command "clip.exe" "$@"
  else
    xclip -h >/dev/null 2>&1 || sudo apt-get install xclip
    exec xclip -selection $SELECTION -i "$@"
  fi
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
    exit 0
    ;;
  *)
    if [ $# -eq 1 ]; then
      if [ -f $1 ]; then
        cat $1 | copy
        exit 0
      fi
    fi
    ;;
esac

copy
