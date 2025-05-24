#!/usr/bin/env bash
set -euo pipefail

BATTERY_DIR=/sys/class/power_supply/BAT0/
percentage="$(cat "$BATTERY_DIR/capacity")"
status="$(cat "$BATTERY_DIR/status")"

icon() {
  [ "$status" = 'Charging' ] && { echo ''; exit; }
  icons=('' '' '' '' '' '' '' '' '' '')
  iconslen="${#icons[@]}"
  ((idx = percentage / iconslen))
  ((idx = idx >= iconslen ? iconslen-1 : idx))
  echo "${icons[$idx]}"
}

case "$#" in
  0) echo "$(icon) $percentage%" ;;
  1)
    case "$1" in
      'percentage') echo "$percentage" ;;
      'status') echo "$status" ;;
      'icon') icon ;;
      *)
        echo 'battery: Invalid argument' >&2
        exit 1
        ;;
    esac
    ;;
  *)
    echo 'battery: Invalid number of arguments' >&2
    exit 1
    ;;
esac
