#!/bin/bash

if [ "$(pulsemixer --get-mute)" = 0 ]; then
  ratpoison -c "echo mute on"
  pulsemixer --toggle-mute
else
  ratpoison -c "echo mute off"
  pulsemixer --toggle-mute
fi
