#!/bin/bash

mkdir $HOME/.fonts

function install_font {
  wget "$1" -O "$HOME/.fonts/$2"
}

install_font "https://github.com/microsoft/cascadia-code/releases/download/v1911.21/Cascadia.ttf" Cascadia.ttf
install_font "https://github.com/microsoft/cascadia-code/releases/download/v1911.21/CascadiaMono.ttf" CascadiaMono.ttf
install_font "https://github.com/microsoft/cascadia-code/releases/download/v1911.21/CascadiaMonoPL.ttf" CascadiaMonoPL.ttf
install_font "https://github.com/microsoft/cascadia-code/releases/download/v1911.21/CascadiaPL.ttf" CascadiaPL.ttf

sudo fc-cache -f -v
