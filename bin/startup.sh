#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get -qq update && apt-get -qq upgrade --yes

# Install/upgrade packages in the VM
apt-get install -qq --yes \
	command-not-found bash-completion \
	build-essential devscripts \
	gcc curl wget \
	tmux vim git zsh \
	npm npm2deb nodejs nodejs-legacy \
	golang golang-go.tools

update-command-not-found

wget https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.40.zip -O /tmp/appengine_sdk.zip
unzip -d /usr/local/ /tmp/appengine_sdk.zip

wget https://github.com/yudai/gotty/releases/download/pre-release/gotty_linux_amd64.tar.gz -O /tmp/gotty_linux_amd64.tar.gz
tar xvf /tmp/gotty_linux_amd64.tar.gz -C /usr/local/bin/

git clone https://github.com/filipenos/dotfiles.git /usr/local/dotfiles/

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo 'export GO15VENDOREXPERIMENT=0' >> /etc/profile
echo 'export GOPATH="$HOME"' >> /etc/profile
echo 'export PATH="$PATH:/usr/local/go_appengine:$GOPATH/bin"' >> /etc/profile
echo 'export PATH="$PATH:/usr/local/dotfiles/bin"' >> /etc/profile
