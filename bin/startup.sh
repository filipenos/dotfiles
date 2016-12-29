#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get -qq update
apt-get -qq upgrade --yes
apt-get install -qq --yes \
	command-not-found bash-completion \
	build-essential devscripts \
	gcc curl wget \
	tmux vim git zsh \
	npm npm2deb nodejs nodejs-legacy \
	golang golang-go.tools

update-command-not-found

git clone https://github.com/filipenos/dotfiles.git /usr/local/dotfiles/
git clone https://github.com/robbyrussell/oh-my-zsh /usr/local/ohmyzsh/

echo 'export GO15VENDOREXPERIMENT=0' >> /etc/profile
echo 'export GOPATH="$HOME"' >> /etc/profile
echo 'export PATH="$PATH:/usr/local/dotfiles/bin"' >> /etc/profile
echo 'source /usr/local/dotfiles/etc/customrc' >> /etc/profile
