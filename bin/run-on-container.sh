#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
usage: $(basename "$0") [image] [command ...]

Default:
  image   alpine
  command /bin/sh

Env vars:
  PORTS       Space/comma-separated port mappings (ex: "8080:8080 9229:9229")
  PULL_POLICY Docker --pull policy (default: always)
EOF
}

require_cmd() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "missing command: $cmd" >&2
    exit 1
  }
}

sanitize_name() {
  local raw="$1"
  local out
  out="$(echo "$raw" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_.-]/-/g; s/^-*//; s/-*$//')"
  if [[ -z "$out" ]]; then
    out="workspace"
  fi
  printf '%s\n' "$out"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

require_cmd docker

IMAGE="alpine"
CMD=("/bin/sh")

if [[ $# -ge 1 ]]; then
  IMAGE="$1"
  shift
fi
if [[ $# -ge 1 ]]; then
  CMD=("$@")
fi

path="$(pwd)"
name="$(sanitize_name "$(basename "$path")")"
mount="/mnt/$name"
pull_policy="${PULL_POLICY:-always}"

run_args=(
  --rm
  --name "$name"
  --pull "$pull_policy"
  -v "$path:$mount"
  -w "$mount"
  -it
)

if [[ -n "${PORTS:-}" ]]; then
  ports_raw="$(echo "${PORTS}" | tr ',' ' ')"
  for mapping in $ports_raw; do
    run_args+=(-p "$mapping")
  done
fi

docker run "${run_args[@]}" "$IMAGE" "${CMD[@]}"
