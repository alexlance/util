#!/bin/bash

#curr=$(amixer sget 'IEC958 Playback Source' | grep Item0 | cut -d "'" -f2)
curr=$(amixer sget 'Headphone' | grep '\[on\]')

if [[ -z "$curr" ]]; then
  amixer sset "Headphone" on  > /dev/null
  ratpoison -c "echo mute off"
else
  amixer sset "Headphone" off  > /dev/null
  ratpoison -c "echo mute on"
fi

