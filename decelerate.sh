#!/bin/bash

pid=$(pgrep -o -f $1)
while [ -n "$pid" ]; do
  echo "$(date +'%F %T') Stopping for 120 $(sensors | grep 'Core0 Temp')"
  kill -STOP $pid
  sleep 120
  echo "$(date +'%F %T') Continuing for 90 $(sensors | grep 'Core0 Temp')"
  kill -CONT $pid
  sleep 90
  pid=$(pgrep -o -f $1)

done

