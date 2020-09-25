#!/bin/bash

cur=$(v4l2-ctl -C exposure_absolute | cut -f2 -d' ')
interval=20

if [ "$1" == "up" ]; then
  let cur+=${interval}
elif [ "$1" == "down" ]; then
  let cur-=${interval}
fi

v4l2-ctl -c exposure_absolute=$cur
ratpoison -c "echo ${cur}"

