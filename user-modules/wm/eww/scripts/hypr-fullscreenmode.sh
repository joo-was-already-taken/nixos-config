#!/usr/bin/env bash

grep 'hasfullscreen:' <<< "$(hyprctl activeworkspace)" | cut -d':' -f2 | tr -d ' '
