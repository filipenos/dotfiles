#!/bin/bash

target_dir="$HOME/.local/share/fonts"
use_sudo=""
tmp_zip="$(mktemp /tmp/jetbrainsfont.XXXXXX.zip)"

cleanup() {
  rm -f "$tmp_zip"
}
trap cleanup EXIT

if [ "$1" = "--system" ]; then
  target_dir="/usr/share/fonts"
  use_sudo="sudo"
fi

wget "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip" -O "$tmp_zip"

$use_sudo mkdir -p "$target_dir"
$use_sudo unzip -d "$target_dir" "$tmp_zip"
$use_sudo fc-cache -f -v
