#!/bin/bash

ignored_players="firefox,chromium"
format='{"title":"{{title}}","artist":"{{artist}}","album":"{{album}}","status":"{{status}}","cover":"{{mpris:artUrl}}"}'

get_song() {
  metadata=$(playerctl metadata -s -i $ignored_players -f $format)

  if [[ -z $metadata ]]; then
    echo "{}"
  else
    echo "$metadata"
  fi
}

stream_song() {
  get_song
  playerctl metadata -s -F -i $ignored_players -f $format |
    while read -r metadata; do 
      if [[ -z $metadata ]]; then
        echo "{}"
      else
        echo "$metadata"
      fi
    done
}

next_song() {
  playerctl next -i $ignored_players
}

previous_song() {
  playerctl previous -i $ignored_players
}

toggle() {
  playerctl play-pause -i $ignored_players
}

volume_up() {
  playerctl volume 0.02+ -i $ignored_players
}

volume_down() {
  playerctl volume 0.02- -i $ignored_players
}

raise_player() {
  hyprctl dispatch focuswindow class:"[Ss]potify" &>/dev/null
}

if [[ $1 == "get" ]]; then
  get_song
elif [[ $1 == "stream" ]]; then
  stream_song
elif [[ $1 == "next" ]]; then
  next_song
elif [[ $1 == "previous" ]]; then
  previous_song
elif [[ $1 == "toggle" ]]; then
  toggle
elif [[ $1 == "volume-up" ]]; then
  volume_up
elif [[ $1 == "volume-down" ]]; then
  volume_down
elif [[ $1 == "raise" ]]; then
  raise_player
fi

