#!/bin/bash

log() {
	echo "[PATH] $@"
}

FILE="$(readlink -f "$0")"
BASE="${FILE%/*}"
BASE="${BASE%/*}"

add_path() {
	if ! grep -q -1 "#CUSTOM_PATH" $HOME/.bashrc ; then
		log "configuring .bashrc"
		echo "source $BASE/etc/customrc #CUSTOM_PATH" >> $HOME/.bashrc
	else
		log "bashrc already configured"
	fi

	if ! grep -q -1 "#CUSTOM_PATH" $HOME/.zshrc ; then
		log "configuring .zshrc"
		echo "source $BASE/etc/customrc #CUSTOM_PATH" >> $HOME/.zshrc
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

help() {
	echo "Usage $0
	-c configure
		Configure your .bashrc|.zshrc to use the customrc
	-r remove
		Remove configuration of customrc to the .bashrc|.zshrc
	-h help
		Show this help"
}

case $1	in
	-c|configure)
		add_path "$@"
		;;
	-r|remove)
		remove "$@"
		;;
	-h|help|*)
		help
		;;
esac

exit 0
