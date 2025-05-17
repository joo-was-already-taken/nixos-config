#!/usr/bin/env bash

EVENT="$1"
SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

if [[ ! -S "$SOCKET" ]]; then
  echo "Hyprland event socket not found at '$SOCKET'" >&2
  exit 1
fi

fullscreenmode=0

handle() {
  if [[ "$EVENT" == 'all' ]]; then
    echo "$1"
  elif [[ "$EVENT" == 'fullscreen' ]]; then
    case "${1%%>>*}" in
      fullscreen)
        fullscreenmode="${1#*>>}"
        echo "$fullscreenmode"
        ;;
      changefloatingmode)
        local floatingmode="${1#*,}"
        if [[ "$fullscreenmode" == 1 ]]; then
          echo $((1-floatingmode))
        else
          echo 0
        fi
        ;;
      workspace)
        fullscreenmode="$(hypr-fullscreenmode)"
        echo "$fullscreenmode"
        ;;
    esac
  elif [[ "$1" == "$EVENT>>"* ]]; then
    case "$EVENT" in
      activewindow) echo "${1#*,}" ;;
      *) echo "${1#*>>}" ;; # submap
    esac
  fi
}
socat -U - UNIX-CONNECT:"$SOCKET" | while read -r line; do handle "$line"; done
