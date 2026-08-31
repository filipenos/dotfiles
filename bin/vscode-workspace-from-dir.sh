#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Uso: $(basename "$0") [diretorio...]" >&2
}

if ! command -v jq >/dev/null 2>&1; then
  echo "Erro: jq nao esta instalado." >&2
  exit 1
fi

dirs=()

if [[ $# -eq 0 ]]; then
  while IFS= read -r -d '' dir; do
    dirs+=("$(cd "$dir" && pwd -P)")
  done < <(find . -mindepth 1 -maxdepth 1 -type d -print0)
else
  for dir in "$@"; do
    if [[ ! -d "$dir" ]]; then
      echo "Erro: diretorio invalido: $dir" >&2
      usage
      exit 1
    fi
    dirs+=("$(cd "$dir" && pwd -P)")
  done
fi

jq -n '
  $ARGS.positional
  | unique
  | sort
  | map({path: .})
  | {folders: ., settings: {}}
' --args "${dirs[@]}"
