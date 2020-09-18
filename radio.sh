#!/bin/bash

if pgrep -f triplej; then
  pkill -f triplej
else
  mplayer -quiet http://www.abc.net.au/res/streaming/audio/mp3/triplej.pls
fi
