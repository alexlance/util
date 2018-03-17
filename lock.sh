#!/bin/bash

export DISPLAY=":0.0"

if pidof xtrlock; then
  banner "unlock"
  killall xtrlock
else
  banner "locked"
  nohup xtrlock -f &
fi

exit 129
