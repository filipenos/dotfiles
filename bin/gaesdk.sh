#!/bin/bash

log() {
	echo "[gaesdk] $@"
}

VERSION="1.9.48"

if [ ! -d "$HOME/lib" ]; then
	mkdir $HOME/lib
fi

if [ -d "$HOME/lib/go_appengine" ]; then
	log "gae sdk already installed, abort..."
	log $(head -n 1 "$HOME/lib/go_appengine/VERSION")
else
	log "downloading $VERSION"
	wget "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-$VERSION.zip" -O /tmp/appengine_sdk.zip
	log "unpacking sdk"
	unzip -q -d $HOME/lib /tmp/appengine_sdk.zip
	log "installation done"
fi



if grep -q -1 "go_appeninge" $HOME/.customrc ; then
	log "configuring .bashrc"
	echo 'export PATH="$PATH:$HOME/lib/go_appengine"' >> $HOME/.customrc
else
	log "skip .customrc configuration"
fi

exit 0
