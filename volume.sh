#!/bin/bash

#if [ "$1" = "up" ]; then
#  pulsemixer --change-volume +10
#  ratpoison -c "echo $(pulsemixer --get-volume)"
#else
#  pulsemixer --change-volume -10
#  ratpoison -c "echo $(pulsemixer --get-volume)"
#fi

if [ "$1" = "up" ]; then
  pulsemixer --change-volume +7
  ratpoison -c "echo $(pulsemixer --get-volume)"
else
  pulsemixer --change-volume -7
  ratpoison -c "echo $(pulsemixer --get-volume)"
fi

if [ "$(pulsemixer --get-mute)" != 0 ]; then
  ratpoison -c "echo mute off: $(pulsemixer --get-volume)"
  pulsemixer --toggle-mute
fi

