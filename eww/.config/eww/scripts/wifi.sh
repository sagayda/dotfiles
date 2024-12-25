#!/bin/bash

get_ssid() {
  iwgetid -r
}

get_signal_strength() {
    res=$(grep "wlan" /proc/net/wireless | awk '{ print ($3 ? int($3 / 70 * 100) : 0) }')
    if [[ -n "$res" ]]; then
        echo "$res"
    else
        echo "0"
    fi
    
}

get_icon() {
  signal=$(get_signal_strength)

  if [[ -z $signal ]]; then
    echo "󰤮"
  elif [[ $signal -gt 75 ]]; then
    echo "󰤨"
  elif [[ $signal -gt 50 ]]; then
    echo "󰤥"   
  elif [[ $signal -gt 25 ]]; then
    echo "󰤢"
  elif [[ $signal -gt 0 ]]; then
    echo "󰤟"
  else
    echo "󰤯"
  fi
}

get_json() {
  echo "{\"ssid\":\"$(get_ssid)\",\"strength\":$(get_signal_strength),\"icon\":\"$(get_icon)\"}"
}

case "$1" in
  "name") get_ssid
  ;;
  "strength") get_signal_strength
  ;;
  "icon") get_icon 
  ;;
  "json") get_json
  ;;
esac

