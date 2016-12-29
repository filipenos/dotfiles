#!/bin/bash

if [ ! -d "$HOME/lib" ]; then
	mkdir $HOME/lib
fi

if [ -d "$HOME/lib/go_appengine" ]; then
	echo "gae sdk already installed, abort..."
	head -n 1 "$HOME/lib/go_appengine/VERSION"
	exit 0
fi

wget https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.48.zip -O /tmp/appengine_sdk.zip
unzip -d $HOME/lib /tmp/appengine_sdk.zip

echo 'export PATH="$PATH:$HOME/lib/go_appengine"' >> $HOME/.customrc
