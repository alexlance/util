#!/bin/bash

DEFAULT_SINK=$(pactl info | grep "Default Sink" | cut -d " " -f3)
if [ "$(pulsemixer --get-mute)" = 0 ]; then
  ratpoison -c "echo mute on"
  #pulsemixer --toggle-mute
  pactl set-sink-mute "$DEFAULT_SINK" "1"
else
  ratpoison -c "echo mute off: $(pulsemixer --get-volume)"
  #pulsemixer --toggle-mute
  pactl set-sink-mute "$DEFAULT_SINK" "0"
fi
