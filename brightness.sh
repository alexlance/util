#!/bin/bash

f="/sys/class/backlight/intel_backlight/brightness"
#f="/sys/class/backlight/mba6x_backlight/brightness"
cur=$(cat $f)

if [ "$1" = "up" ]; then
  let cur+=100
  echo $cur > $f
elif [ "$1" = "down" ]; then
  let cur-=100
  echo $cur > $f
fi

