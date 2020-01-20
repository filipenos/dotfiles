#!/bin/bash

wget "https://download.jetbrains.com/fonts/JetBrainsMono-1.0.0.zip" -O /tmp/jetbrainsfont.zip

mkdir $HOME/.fonts
unzip -d $HOME/.fonts /tmp/jetbrainsfont.zip
sudo fc-cache -f -v

rm -r /tmp/jetbrainsfont.zip
