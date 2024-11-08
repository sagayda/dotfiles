#!/bin/bash

function handle_workspace {
  if [[ ${1:0:11} != "workspace>>" ]]; then
    return 1
  fi

  echo "$1" | awk -F'workspace>>' '{print $2}' | awk '{print $1}'
}

hyprctl activeworkspace | grep -oP 'workspace ID \K\d+'

nc -U "/$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
  while read -r line; do
    handle_workspace "$line"
  done
