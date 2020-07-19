#!/bin/bash

h="$(hostname)"

if [ "${h}" == "sansa" ]; then
  f="/sys/class/backlight/acpi_video0/brightness" # sansa
  cur=$(cat $f)
  interval=500
elif [ "${h}" == "blue" ]; then
  f="/sys/class/backlight/mba6x_backlight/brightness"
else
  f="/sys/class/backlight/intel_backlight/brightness"
  cur=$(cat $f)
  interval=1500
  [ "${cur}" -lt 1600 ] && [ "${1}" = "down" ] && interval=500
  [ "${cur}" -lt 600 ]  && [ "${1}" = "down" ] && interval=100
  [ "${cur}" -lt 600 ]  && [ "${1}" = "up" ]   && interval=100
  [ "${cur}" -gt 400 ]  && [ "${1}" = "up" ]   && interval=500
  [ "${cur}" -gt 1400 ] && [ "${1}" = "up" ]   && interval=1500
fi

if [ "$1" == "up" ]; then
  let cur+=${interval}
  echo $cur > $f
elif [ "$1" == "down" ]; then
  let cur-=${interval}
  echo $cur > $f
fi

cur=$(cat $f)
ratpoison -c "echo ${cur}"
