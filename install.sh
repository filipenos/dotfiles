#/bin/bash

log() {
	echo "[DOTFILES] $@"
}

install() {
	log "installing dotfiles on $HOME"
	git clone -q https://git@github.com/filipenos/dotfiles "$HOME/dotfiles"
	log "dotfiles installed on $HOME"
}

install_customrc() {
	echo "configuring customrc"
	$HOME/dotfiles/bin/custom-path.sh -c
}

install_vim() {
	log "configuring vimrc"
	$HOME/dotfiles/bin/vim-install-vundle
}

install_tmux() {
	log "configuring tmux.conf"
	ln -s $HOME/dotfiles/etc/tmux.conf $HOME/.tmux.conf
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
	install_customrc	

	log "adding dotfiles to path"
	echo 'export PATH="$PATH:$HOME/dotfiles/bin"' >> $HOME/.customrc
fi

log "installation occurred successfully! have a good time"
exit 0
