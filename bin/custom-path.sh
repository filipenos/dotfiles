#!/bin/bash

log() {
	echo "[PATH] $@"
}

FILE="$(readlink -f "$0")"
BASE="${FILE%/*}"
BASE="${BASE%/*}"

configure_path() {
	if ! grep -q -1 "#CUSTOM_PATH" $HOME/.bashrc ; then
		log "configuring .bashrc"
		echo "source $BASE/customrc.sh #CUSTOM_PATH" >> $HOME/.bashrc
		echo "source $BASE/custompath.sh #CUSTOM_PATH" >> $HOME/.bashrc
    echo ". $BASE/completions.sh #CUSTOM_PATH" >> $HOME/.bashrc
	else
		log "bashrc already configured"
	fi

	if ! grep -q -1 "#CUSTOM_PATH" $HOME/.zshrc ; then
		log "configuring .zshrc"
		echo "source $BASE/customrc.sh #CUSTOM_PATH" >> $HOME/.zshrc
		echo "source $BASE/custompath.sh #CUSTOM_PATH" >> $HOME/.zshrc
    echo ". $BASE/completions.sh #CUSTOM_PATH" >> $HOME/.zshrc
	else
		log "zshrc already configured"
	fi
}

remove() {
	log "remove custom path from .bashrc"
	sed -i '/CUSTOM_PATH/d' "$HOME/.bashrc"
	log "remove custom path from .zshrc"
	sed -i '/CUSTOM_PATH/d' "$HOME/.zshrc"
}

add_to_path() {
  touch ~/.custompath
  log "Adding $2 to custom path"
  echo "$2" >> ~/.custompath
}

show_path() {
  echo "$PATH" | tr ':' '\n'
}

help() {
  echo "Usage $0
  -c configure
    Configure your .bashrc|.zshrc to use the customrc
  -r remove
    Remove configuration of customrc to the .bashrc|.zshrc
  -p show-path
    Show current path
  -a add
    Add to custom path
  -h help
    Show this help"
}

case $1	in
  -c|configure)
    configure_path "$@"
    ;;
  -r|remove)
    remove "$@"
    ;;
  -a|add)
    add_to_path "$@"
    ;;
  -p|show-path)
    show_path
    ;;
  -h|help|*)
    help
    ;;
esac

exit 0
