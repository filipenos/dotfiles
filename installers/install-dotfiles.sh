#/bin/bash

log() {
	echo "[DOTFILES] $@"
}

configure() {
	log "adding dotfiles to custom_path"
	echo 'export PATH="$PATH:$HOME/dotfiles/bin"' >> $HOME/.customrc
}

install() {
	log "installing dotfiles on $HOME"
	git clone -q https://git@github.com/filipenos/dotfiles "$HOME/dotfiles"

	configure
}

install_vim() {
  log "configuring vimrc"
  $HOME/dotfiles/bin/vim-install-vundle
}

install_customrc() {
  log "configuring customrc"
  $HOME/dotfiles/bin/custom-path.sh -c
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
	install_customrc	
	install_tmux
fi

log "installation occurred successfully! have a good time"
exit 0
