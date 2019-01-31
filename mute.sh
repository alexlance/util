#!/bin/bash


if [ "$(pulsemixer --get-mute)" = 0 ]; then
  ratpoison -c "echo mute on"
  pulsemixer --toggle-mute
else
  ratpoison -c "echo mute off"
  pulsemixer --toggle-mute
fi

#curr=$(amixer sget 'IEC958 Playback Source' | grep Item0 | cut -d "'" -f2)
#curr=$(amixer sget 'IEC958' | grep 'Mono: Playback \[on\]')
#curr=$(amixer sget 'Master' | grep '\[on\]')
#
#if [[ -z "$curr" ]]; then
#  amixer sset "Master" on  > /dev/null
#  ratpoison -c "echo mute off"
#else
#  amixer sset "Master" off  > /dev/null
#  ratpoison -c "echo mute on"
#fi

