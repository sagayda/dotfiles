#!/bin/bash

if [[ ! "$1" || ! "$2" || $2 != +([0-9])?(.+([0-9])) ]]; then
  exit 1
fi

widget_name="$1"
time="$2"
lockfile="/tmp/${widget_name}_lock"

eww open "$widget_name" $3
echo "$$" > "$lockfile"

sleep $time

[[ $(cat "$lockfile") == "$$" ]] && eww close "$widget_name"
