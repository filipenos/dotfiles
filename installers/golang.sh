#!/bin/bash

log() {
	echo "[golang] $@"
}

GO16="go1.6.4.linux-amd64.tar.gz"
GO17="go1.7.4.linux-amd64.tar.gz"

if [ ! -d "$HOME/lib" ]; then
	log "creating local lib path $HOME/lib"
	mkdir $HOME/lib
fi

if [ -d "$HOME/lib/go" ]; then
	log "golang already installed, abort..."
	log $(head -n 1 "$HOME/lib/go/VERSION")
else
	log "downloading ..."
	wget "https://storage.googleapis.com/golang/$GO16" -O "/tmp/go.tar.gz"
	log "unpacking golang"
	tar -C "$HOME/lib" -xzf "/tmp/go.tar.gz"
	log "installation done"
fi



if ! grep -q -1 "GOROOT" "$HOME/.customrc"
then
	log "configuring .customrc"
	echo 'export GOROOT="$HOME/lib/go"' >> "$HOME/.customrc"
	echo 'export PATH="$PATH:$GOROOT/bin"' >> "$HOME/.customrc"
	log "configation done"
else
	log "skip .customrc configuration"
fi

exit 0
