#!/bin/bash

f="/sys/class/leds/smc::kbd_backlight/brightness"
cur=$(cat $f)

if [ "$1" = "up" ]; then
  let cur+=5
  echo $cur > $f
elif [ "$1" = "down" ]; then
  let cur-=5
  echo $cur > $f
fi

