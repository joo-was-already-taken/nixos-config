#!/usr/bin/env bash
set -euo pipefail

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

arg="$1"

non-empty() {
  hyprctl workspaces | awk '/^workspace/ {print $3}' | sort -n
} 
all() {
  non-empty | tail -n 1 | xargs seq
}

get-workspaces() {
  case "$arg" in
    non-empty) non-empty | xargs ;;
    empty) comm -23 <(all | sort) <(non-empty | sort) | xargs ;;
    all) all | xargs ;;
    # combined)
    #   local nonempty
    #   nonempty="$(non-empty | xargs)"
    #   local combined=""
    #   for ws in $(all); do
    #     if [[ " $nonempty " =~ $ws ]]; then
    #       combined+="$ws 1 "
    #     else
    #       combined+="$ws 0 "
    #     fi
    #   done
    #   echo "$combined"
    #   ;;
  esac
}

get-workspaces
socat -U - UNIX-CONNECT:"$SOCKET" | while read -r line; do
  if [[ "$line" == 'workspace>>'* ]]; then
    get-workspaces
  fi
done
