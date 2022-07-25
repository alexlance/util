#!/bin/bash

set -x

cur=$(v4l2-ctl -C exposure_absolute | cut -f2 -d' ')
interval=20

if [ "$1" == "up" ]; then
  let cur+=${interval}
  v4l2-ctl -c exposure_absolute=$cur
  ratpoison -c "echo ${cur}"
elif [ "$1" == "down" ]; then
  let cur-=${interval}
  v4l2-ctl -c exposure_absolute=$cur
  ratpoison -c "echo ${cur}"
elif [ $1 == "reset" ]; then
  v4l2-ctl -c white_balance_temperature_auto=0
  #v4l2-ctl -c white_balance_temperature=3929
  v4l2-ctl -c white_balance_temperature=3300
  v4l2-ctl -c brightness=41
  v4l2-ctl -c contrast=29
  v4l2-ctl -c saturation=72
  v4l2-ctl -c hue='0'
  v4l2-ctl -c gamma=220
  v4l2-ctl -c exposure_auto=1
  #v4l2-ctl -c exposure_absolute=315
  v4l2-ctl -c exposure_absolute=1000
  #v4l2-ctl -c power_line_frequency=3
  v4l2-ctl -c sharpness=7
  v4l2-ctl -c backlight_compensation=1
  v4l2-ctl -c iris_relative=12
fi


