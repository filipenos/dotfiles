#!/bin/bash

mkdir -p "$HOME/Imagens/PrintScreen"

name="$HOME/Imagens/PrintScreen/screenshot"
if [[ -e $name.png ]] ; then
    i=0
    while [[ -e $name-$i.png ]] ; do
        let i++
    done
    name=$name-$i
fi
name="$name".png

scrot -s "$name" -e 'gpicview $f'
