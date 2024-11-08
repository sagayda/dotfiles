#!/bin/bash

function handle_layout {
  if [[ ${1:0:12} != "activelayout" ]]; then
    return 1
  fi

  echo "$1" | awk -F',' '{print tolower(substr($NF, 1, 3))}' | sed 's/^ *//;s/ *$//'
}

hyprctl devices | grep -A 3 "$DEVICE$" | grep "active keymap:" | tail -n 1 | awk '{print tolower(substr($3,1,3))}'

nc -U "/$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
  while read -r line; do
    handle_layout "$line"
  done
