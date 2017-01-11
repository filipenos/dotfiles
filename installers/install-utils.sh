#!/bin/bash

log() {
	echo "[INSTALL] $@"
}

case "$1" in
	ohmyzsh)
		log "installing oh-my-zsh"
		sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
		log "installation done"
		exit 0
		;;

	tpm)
		log "installing tmux plugin manager (tpm)"
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
		log "installation done"
		;;

  funcoeszz)
    log "installing funcoeszz"
    wget "http://funcoeszz.net/download/funcoeszz-15.5.sh" -O "$HOME/bin/funcoeszz-15.5.sh"
    chmod +x "$HOME/bin/funcoeszz-15.5.sh"
    log "installation done"
    ;;

	*)
		echo "install custom resource"
    echo "    {ohmysql|tpm|funcoeszz}"
		;;
esac
