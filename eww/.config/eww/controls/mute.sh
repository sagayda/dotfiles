#!/bin/bash

if [[ ! "$1" || ! "$2" ]]; then
  exit 1
fi

if [[ "$1" == "sink" ]]; then
  target="DEFAULT_SINK"
elif [[ "$1" == "source" ]]; then
  target="DEFAULT_SOURCE"
else
  exit 2
fi

command=$2

result=$(~/.config/eww/scripts/toggle-mute.lua "{\"id\":\"$target\",\"command\":\"$command\"}")

if [[ "$result" == "true" ]]; then
  [[ "$target" == "DEFAULT_SOURCE" ]] && icon="" || icon=""
elif [[ "$result" == "false" ]]; then
  [[ "$target" == "DEFAULT_SOURCE" ]] && icon="" || icon=""
else
  exit 3
fi

# echo $icon

~/.config/eww/scripts/open-for.sh icon-popup 1 "--arg icon=$icon"
