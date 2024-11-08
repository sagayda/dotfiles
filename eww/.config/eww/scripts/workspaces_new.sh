#!/bin/bash

# active=$(hyprctl activeworkspace | grep -oP 'workspace ID \K\d+')

get_workspaces() {

  hyprctl workspaces | awk '/^workspace ID/ {id=$3} /\twindows:/ && id >= 0 {print id, $2}' | sort -n
  
}

get_active() {
  hyprctl activeworkspace | grep -oP 'workspace ID \K\d+'
}

get_workspaces_json() {
  
  active=$(get_active)

  get_workspaces | while read -r id windows; do
    if [ "$id" -eq "$active" ]; then
      state="true"
    else
      state="false"
    fi

    echo "{\"id\":${id},\"windows\":$windows,\"is_active\":$state}"
  done | jq -sc
}

get_active

nc -U "/$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
  while read -r line; do
    if [[ "$line" == "workspace>>"* ]]; then
      # get_workspaces_json
      get_active
    fi
  done
