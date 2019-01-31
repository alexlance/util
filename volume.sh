#!/bin/bash

if [ "$(hostname)" = "leaf" ]; then
  if [ "$1" = "up" ]; then
    if pactl list short sinks | grep bluez; then
      # little orange bose speaker
      pactl set-sink-volume bluez_sink.2C_41_A1_15_2F_8B.a2dp_sink +10%
    else
      amixer set Master 3000+ > /dev/null
    fi
  elif [ "$1" = "down" ]; then
    if pactl list short sinks | grep bluez; then
      pactl set-sink-volume bluez_sink.2C_41_A1_15_2F_8B.a2dp_sink -10%
    else
      amixer set Master 3000- > /dev/null
    fi
  fi
elif [ "$(hostname)" = "lyra" ]; then

  if [ "$1" = "up" ]; then
    pulsemixer --change-volume +10
  else
    pulsemixer --change-volume -10
  fi

else
  if [ "$1" = "up" ]; then
    amixer set Master 3000+ > /dev/null
  elif [ "$1" = "down" ]; then
    amixer set Master 3000- > /dev/null
  fi
fi
