#!/bin/bash

# ./delay.sh <var_name> <value> [delay]

if [[ ! $1 || ! $2 ]]; then
  exit 1;
fi

var_name=$1
timer_file="/tmp/${var_name}_reset_timer.pid" # tmp file to store timers PID
eww_cmd="eww"

run_timer() {
  sleep $delay
  $eww_cmd update $var_name=$1
  rm -f "$timer_file"
}

set() {
  # kill all running timers
  if [[ -f "$timer_file" ]]; then
    kill "$(cat $timer_file)" 2>/dev/null
    rm -f "$timer_file"
  fi

  $eww_cmd update $var_name=$1
}

set_delayed() {
  run_timer $1 & # start timer func in background
  echo $! > "$timer_file" # end save it's pid
}

# if delay set and is number 
if [[ $3 && $3 == +([0-9])?(.+([0-9])) ]]; then
  delay=$3
  set_delayed $2
else
  set $2  
fi

