#!/usr/bin/env bash
set -euo pipefail

# Linux exposes hardware temperature sensors through hwmon.
interval=${1:-1}

if [[ ! $interval =~ ^[0-9]+([.][0-9]+)?$ ]] || [[ $interval == 0 ]]; then
  echo "Uso: temps.sh [intervalo_em_segundos]" >&2
  exit 1
fi

if [[ ! -d /sys/class/hwmon ]]; then
  echo "Sensores de temperatura não estão disponíveis neste sistema." >&2
  exit 1
fi

sensor_label() {
  local device=$1
  local label=$2

  case "$device:$label" in
    k10temp:Tctl)       echo "CPU" ;;
    amdgpu:edge)        echo "GPU" ;;
    nvme:Composite)     echo "SSD" ;;
    nvme:"Sensor 1")   echo "SSD controlador" ;;
    nvme:"Sensor 2")   echo "SSD memória" ;;
    *)                  echo "$device ${label:-sensor}" ;;
  esac
}

temperature_color() {
  local value=$1

  if (( value >= 95000 )); then
    printf '\033[1;31m'
  elif (( value >= 85000 )); then
    printf '\033[1;33m'
  else
    printf '\033[0;32m'
  fi
}

trap 'printf "\033[0m\n"; exit 0' INT TERM

while true; do
  printf '\033[H\033[2J'
  printf 'Temperaturas — %s\n\n' "$(date '+%d/%m/%Y %H:%M:%S')"

  found=false
  for hwmon in /sys/class/hwmon/hwmon*; do
    [[ -r "$hwmon/name" ]] || continue
    device=$(<"$hwmon/name")

    for input in "$hwmon"/temp*_input; do
      [[ -r "$input" ]] || continue
      value=$(<"$input")
      [[ $value =~ ^[0-9]+$ ]] || continue

      label_file=${input%_input}_label
      label=""
      [[ -r "$label_file" ]] && label=$(<"$label_file")

      name=$(sensor_label "$device" "$label")
      color=$(temperature_color "$value")
      awk -v name="$name" -v value="$value" -v color="$color" \
        'BEGIN {printf "%-18s %s%5.1f °C\033[0m\n", name ":", color, value / 1000}'
      found=true
    done
  done

  if [[ $found == false ]]; then
    echo "Nenhum sensor de temperatura encontrado."
    exit 1
  fi

  printf '\nVerde: normal · Amarelo: ≥85 °C · Vermelho: ≥95 °C · Ctrl+C encerra\n'
  sleep "$interval"
done
