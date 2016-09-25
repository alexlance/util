#!/bin/bash

if [ "$1" = "up" ]; then
  amixer set Master 2dB+ > /dev/null
elif [ "$1" = "down" ]; then
  amixer set Master 2dB- > /dev/null
fi

