#!/bin/sh

bat=/sys/class/power_supply/BAT1/
# per="$(cat "$bat/capacity")"
# stat="$(cat "$bat/status")"

get_percent() {
  cat "$bat/capacity"
}

get_status() {
  cat "$bat/status"
}

get_icon() {
  
  if [[ $(get_status) != "Discharging" ]]; then
    echo "󰂄"
    return
  fi
  
  percent=$(get_percent)

  if [ "$percent" -gt "95" ]; then
    echo "󰁹"
  elif [ "$percent" -gt "90" ]; then
    echo "󰂂"
  elif [ "$percent" -gt "80" ]; then
    echo "󰂁"
  elif [ "$percent" -gt "70" ]; then
    echo "󰂀"
  elif [ "$percent" -gt "60" ]; then
    echo "󰁿"
  elif [ "$percent" -gt "50" ]; then
    echo "󰁾"
  elif [ "$percent" -gt "40" ]; then
    echo "󰁾"
  elif [ "$percent" -gt "30" ]; then
    echo "󰁽"
  elif [ "$percent" -gt "20" ]; then
    echo "󰁼"
  elif [ "$percent" -gt "10" ]; then
    echo "󰁻"
  elif [ "$percent" -gt "5" ]; then
    echo "󰁺"
  else
    echo "󰂃"
  fi
}

get_color() {
  percent=$(get_percent)

  if [ "$percent" -gt "50" ]; then
    echo "#a3be8c"
  elif [ "$percent" -gt "20"]; then
    echo "#ebcb8b"
  else
    echo "#bf616a"
  fi
}

get_json() {
  echo "{\"status\":\"$(get_status)\",\"percent\":$(get_percent),\"icon\":\"$(get_icon)\",\"color\":\"$(get_color)\"}"
}

case "$1" in 
  "percent") get_percent
  ;;
  "status") get_status
  ;;
  "color") get_color
  ;;
  "icon") get_icon
  ;;
  "json") get_json
  ;;
esac
