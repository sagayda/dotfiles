#!/bin/bash

dev=$(ls /sys/class/backlight/)

get_percent() {
  brightnessctl -d $dev g |  awk '{printf "%.0f\n", $1 / 255 * 100}'
}

set_percent() {
  
  brightness=$1

  if [[ $brightness -lt 5 ]]; then
    brightness=5
  elif [[ $brightness -gt 100 ]]; then
    brightness=100
  fi

  brightnessctl -d $dev s $brightness% > /dev/null
}

get_icon() {
  brightness=$(get_percent)

  if [[ $brightness -gt 75 ]]; then
    echo "󰃠"
  elif [[ $brightness -gt 50 ]]; then
    echo "󰃝"
  elif [[ $brightness -gt 25 ]]; then
    echo "󰃟"
  else
    echo "󰃞"
  fi
}

if [[ "$1" == "get-percent" ]]; then
  get_brightness
elif [[ "$1" == "get-icon" ]]; then
  get_icon
elif [[ "$1" == "stream-percent" ]]; then
  get_percent
  inotifywait -qm -e close_write "/sys/class/backlight/$dev/brightness" |
    while read -r; do
      get_percent
    done
elif [[ "$1" == "stream-icon" ]]; then
  get_icon
  inotifywait -qm -e close_write "/sys/class/backlight/$dev/brightness" |
    while read -r; do
      get_icon
    done
elif [[ "$1" == "set-percent" ]]; then
  set_percent $2
fi
