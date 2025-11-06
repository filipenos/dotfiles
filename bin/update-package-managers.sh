#!/usr/bin/env bash
set -euo pipefail

ensure_not_root() {
  if [ "${EUID:-$(id -u)}" -eq 0 ]; then
    printf '[%s] Este script não deve ser executado com sudo/root.\n' "$(date +'%Y-%m-%d %H:%M:%S')" >&2
    printf '       Execute sem sudo; o script usará sudo apenas onde necessário.\n' >&2
    exit 1
  fi
}

log() {
  printf '[%s] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*"
}

run_privileged() {
  if command -v sudo >/dev/null 2>&1 && [ "${EUID:-$(id -u)}" -ne 0 ]; then
    sudo "$@"
  else
    "$@"
  fi
}

run_apt() {
  if command -v apt >/dev/null 2>&1; then
    log "Atualizando via apt (sudo requerido)..."
    run_privileged apt update
    run_privileged apt upgrade -y
    run_privileged apt autoremove -y
    log "apt finalizado."
  else
    log "Ignorando apt: comando não encontrado."
  fi
}

run_snap() {
  if command -v snap >/dev/null 2>&1; then
    log "Atualizando via snap (sudo requerido)..."
    run_privileged snap refresh
    log "snap finalizado."
  else
    log "Ignorando snap: comando não encontrado."
  fi
}

run_brew() {
  if command -v brew >/dev/null 2>&1; then
    log "Atualizando via brew..."
    brew update
    brew upgrade
    brew cleanup
    log "brew finalizado."
  else
    log "Ignorando brew: comando não encontrado."
  fi
}

run_npm() {
  if command -v npm >/dev/null 2>&1; then
    log "Atualizando via npm..."
    npm update -g
    log "npm finalizado."
  else
    log "Ignorando npm: comando não encontrado."
  fi
}

main() {
  ensure_not_root
  local platform
  platform="$(uname -s || echo unknown)"

  case "$platform" in
    Linux)
      log "Sistema detectado: Linux"
      run_apt
      run_snap
      run_brew
      run_npm
      ;;
    Darwin)
      log "Sistema detectado: macOS"
      run_brew
      run_npm
      ;;
    *)
      log "Sistema operacional desconhecido (${platform}). Executando apenas gerenciadores independentes."
      run_brew
      run_npm
      ;;
  esac

  log "Atualização concluída."
}

main "$@"
