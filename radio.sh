#!/bin/bash

if pgrep -f mediaserviceslive; then
  pkill -f mediaserviceslive
else
  #mplayer -quiet http://www.abc.net.au/res/streaming/audio/mp3/triplej.pls
  #mplayer -nocache -quiet http://live-radio01.mediahubaustralia.com/2TJW/mp3/
  # double J
  ffplay -loglevel -8 -i https://mediaserviceslive.akamaized.net/hls/live/2038315/doublejnsw/index.m3u8 &
fi
