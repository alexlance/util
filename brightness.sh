#!/bin/bash

f="/sys/class/backlight/intel_backlight/brightness"
#f="/sys/class/backlight/mba6x_backlight/brightness"
[ $(hostname) == "sansa" ] && f="/sys/class/backlight/acpi_video0/brightness" # sansa
cur=$(cat $f)

if [ "$1" = "up" ]; then
  let cur+=100
  echo $cur > $f
elif [ "$1" = "down" ]; then
  let cur-=100
  echo $cur > $f
fi

