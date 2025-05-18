#!/usr/bin/env bash
set -euo pipefail

grep 'hasfullscreen:' <<< "$(hyprctl activeworkspace)" | cut -d':' -f2 | tr -d ' '
