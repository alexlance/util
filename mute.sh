#!/bin/bash

#curr=$(amixer sget 'IEC958 Playback Source' | grep Item0 | cut -d "'" -f2)
curr=$(amixer sget 'IEC958' | grep 'Mono: Playback \[on\]')

if [[ -z "$curr" ]]; then
  amixer sset "IEC958" on  > /dev/null
  ratpoison -c "echo mute off"
else
  amixer sset "IEC958" off  > /dev/null
  ratpoison -c "echo mute on"
fi

