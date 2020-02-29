#!/bin/bash

if [ "$1" == "install" ]; then
  echo "install my extensions"
  while IFS= read -r ext
  do
    code --install-extension $ext --force
  done < "my_extensions"
else
  echo "save my extensions"
  code --list-extensions > my_extensions
  cat my_extensions
fi
