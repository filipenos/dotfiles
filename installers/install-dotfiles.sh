#/bin/bash

log() {
	echo "[DOTFILES] $@"
}

install() {
	log "installing dotfiles on $HOME"
	git clone -q https://git@github.com/filipenos/dotfiles "$HOME/dotfiles"
}

install_vim() {
	log "configuring vimrc"
	$HOME/dotfiles/bin/vim-install-vundle
}

install_tmux() {
	log "configuring tmux.conf"
	ln -s $HOME/dotfiles/tmux.conf $HOME/.tmux.conf
}

remove() {
	log "removing dotfiles from $HOME"
	rm -rf $HOME/dotfiles
}

if [ -d "$HOME/dotfiles" ]; then
	log "dotfiles already installed, updating..."
	git -C "$HOME/dotfiles" pull
else
	install
	install_vim
	install_tmux
fi

log "installation occurred successfully! have a good time"
exit 0
