#!/bin/bash

get_percent() {
  wpctl get-volume @DEFAULT_SINK@ | awk -F': ' '{print $2 * 100}'
}

set_percent() {
  volume=$1
 
  if [[ $volume -lt 0 ]]; then
    volume=0
  elif [[ $volume -gt 100 ]]; then
    volume=100
  fi

  wpctl set-volume @DEFAULT_SINK@ $volume% 
}

if [[ "$1" == "get-percent" ]]; then
 get_percent
elif [[ "$1" == "stream-percent" ]]; then
  get_percent
  pactl subscribe |
    while read -r line; do
      if [[ $line =~ sink ]]; then
        get_percent
      fi
    done
elif [[ "$1" == "set-percent" ]]; then
  set_percent $2
fi
