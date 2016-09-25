#!/bin/bash -x

cmd="ssh -p 443 -f -N -R 3334:localhost:22 alla@silver2.silverband.com.au"

while true; do

  $cmd

  sleep 3600; # one hour

  pid="$(pgrep -d ' ' -f "$cmd")"

  if [ -n "${pid}" ]; then
    for i in ${pid}; do
      # Don't use kill -9 ! It doesn't let the remote server free up the port
      kill $i
    done
    sleep 20;
  fi

done
