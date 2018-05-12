#/bin/bash

log() {
	echo "[DOTFILES] $@"
}

install() {
	log "installing dotfiles on $HOME"
	git clone -q https://git@github.com/filipenos/dotfiles "$HOME/dotfiles"
}

configure_onpath() {
	log "configure dotfiles on bashrc"
	if ! grep -q "#DOTFILESRC" $HOME/.bashrc ; then
		echo 'source $HOME/dotfiles/dotfilesrc #DOTFILESRC' >> $HOME/.bashrc
	else
		log "bashrc already configured"
	fi
	log "configure dotfiles on zshrc"
	if ! grep -q "#DOTFILESRC" $HOME/.zshrc ; then
		echo 'source $HOME/dotfiles/dotfilesrc #DOTFILESRC' >> $HOME/.zshrc
	else
		log "zshrc already configured"
	fi
	log "reload your sh shell to use dotfiles"
}

remove_frompath() {
	log "remove dotfilesrc from .bashrc"
	sed -i '/DOTFILESRC/d' "$HOME/.bashrc"
	log "remove dotfilesrc from .zshrc"
	sed -i '/DOTFILESRC/d' "$HOME/.zshrc"
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
configure_onpath
#remove_frompath

log "installation occurred successfully! have a good time"
exit 0
