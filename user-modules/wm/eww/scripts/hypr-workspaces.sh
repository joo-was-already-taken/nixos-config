#!/usr/bin/env bash
set -euo pipefail

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

arg="$1"

non-empty() {
  hyprctl workspaces | grep '^workspace' | awk '{print $3}'
}
all() {
  non-empty | tail -n 1 | xargs seq
}
array-to-json() {
  echo "$@" | jq -RMsc 'split("\n") | map(select(. != ""))'
}

get-workspaces() {
  case "$arg" in
    non-empty) array-to-json "$(non-empty)" ;;
    empty) array-to-json "$(comm -23 <(all | sort) <(non-empty | sort))" ;;
    all) array-to-json "$(all)" ;;
  esac
}

get-workspaces
socat -U - UNIX-CONNECT:"$SOCKET" | while read -r line; do
  if [[ "$line" == 'workspace>>'* ]]; then
    get-workspaces
  fi
done
