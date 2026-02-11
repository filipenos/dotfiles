#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[DOTFILES] $*"
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[DOTFILES] missing required command: $cmd" >&2
    exit 1
  fi
}

append_source_once() {
  local file="$1"
  local line='source $HOME/dotfiles/dotfilesrc #DOTFILESRC'

  touch "$file"
  if grep -q "#DOTFILESRC" "$file"; then
    log "$(basename "$file") already configured"
    return 0
  fi
  echo "$line" >> "$file"
}

remove_dotfilesrc_marker() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  awk '!/DOTFILESRC/' "$file" > "${file}.tmp"
  mv "${file}.tmp" "$file"
}

install_repo() {
  log "installing dotfiles on $HOME"
  git clone -q "https://github.com/filipenos/dotfiles.git" "$HOME/dotfiles"
}

configure_onpath() {
  log "configure dotfiles on bashrc"
  append_source_once "$HOME/.bashrc"
  log "configure dotfiles on zshrc"
  append_source_once "$HOME/.zshrc"
  log "reload your sh shell to use dotfiles"
}

remove_frompath() {
  log "remove dotfilesrc from .bashrc"
  remove_dotfilesrc_marker "$HOME/.bashrc"
  log "remove dotfilesrc from .zshrc"
  remove_dotfilesrc_marker "$HOME/.zshrc"
}

install_vim() {
  log "configuring vimrc"
  "$HOME/dotfiles/bin/vim-install-vundle"
}

install_nvim() {
  log "configuring nvimrc"
  mkdir -p "$HOME/.config/nvim"
  ln -sfn "$HOME/dotfiles/init.vim" "$HOME/.config/nvim/init.vim"
}

remove() {
  log "removing dotfiles from $HOME"
  rm -rf "$HOME/dotfiles"
}

main() {
  if [[ "${1:-}" == "remove" ]]; then
    remove_frompath
    remove
    log "dotfiles removed"
    return 0
  fi
  
  require_cmd git

  if [[ -d "$HOME/dotfiles" ]]; then
    log "dotfiles already installed, updating..."
    git -C "$HOME/dotfiles" pull --ff-only
  else
    install_repo
  fi
  configure_onpath

  install_vim
  install_nvim

  log "installation occurred successfully! have a good time"
}

main "${1:-}"
