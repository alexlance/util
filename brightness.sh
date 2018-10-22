#!/bin/bash

for f in /sys/class/backlight/intel_backlight/brightness  /sys/class/backlight/mba6x_backlight/brightness  /sys/class/backlight/acpi_video0/brightness; do

if [ -f ${f} ]; then
echo $f

  cur=$(cat $f)

  if [ "$1" = "up" ]; then
    let cur+=10
    echo $cur > $f
  elif [ "$1" = "down" ]; then
    let cur-=10
    echo $cur > $f
  fi
fi

done
