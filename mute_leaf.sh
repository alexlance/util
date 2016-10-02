#!/bin/bash

if amixer sget Master | grep '\[off\]'; then
  amixer sset Master unmute > /dev/null
  ratpoison -c "echo mute off"
else
  amixer sset Master mute > /dev/null
  ratpoison -c "echo mute on"
fi
