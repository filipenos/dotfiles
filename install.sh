#!/bin/sh

log() {
	echo "[DOTFILES] $@"
}

install() {
	log "installing dotfiles on $HOME"
	git clone -q https://git@github.com/filipenos/dotfiles "$HOME/dotfiles"
}

update() {
	log "dotfiles already installed, updating..."
	git -C "$HOME/dotfiles" pull
}

if [ -d "$HOME/dotfiles" ]; then
  update
else
  install
fi
