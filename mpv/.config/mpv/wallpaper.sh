#!/bin/bash

socet="/tmp/mpv-socket";
wp_dir="/home/sagayda/Hidamari/";
mpv_args="no-audio loop";
proc=$(pgrep mpvpaper | head -n1);

init() {
  if [[ $proc ]]; then
    >&2 echo "mpvpaper is already running, aborting..."
    return;
  fi

  mpvpaper -f -o "$mpv_args input-ipc-server=$socet" '*' $wp_dir
}

kill(){
  if [[ -z $proc ]]; then
    >&2 echo "mpvpaper is not running, aborting..."
    return;
  fi

  echo 'stop' | socat - "$socet" &>/dev/null
}

pause() {
  if [[ ! $proc ]]; then
    >&2 echo "mpvpaper is not running."
    return;
  fi

  echo '{ "command": ["set_property", "pause", true] }' | socat - "$socet" &>/dev/null
}

play() {
  if [[ ! $proc ]]; then
    >&2 echo "mpvpaper is not running."
    return;
  fi
  
  echo '{ "command": ["set_property", "pause", false] }' | socat - "$socet" &>/dev/null
}

toggle() {
  echo '{"command": ["cycle", "pause"]}' | socat - "$socet" 
}

load() {
  echo "loadfile $1" | socat - "$socet"
}

get_frame() {
  path="$1";

  if [[ ! $path ]]; then
      path="screenshot.png"
  fi
  
  echo "{\"command\": [\"screenshot-to-file\", \"$path\"]}" | socat - "$socet"
}

case "$1" in
  init) init 
  ;;
  pause) pause
  ;;
  play) play
  ;;
  toggle) toggle
  ;;
  load) load $2
  ;;
  kill) kill
  ;;
  frame) get_frame $2
  ;;
esac
