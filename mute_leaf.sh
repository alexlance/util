#!/bin/bash

if amixer sget Master | grep '\[off\]'; then
  amixer sset Master unmute > /dev/null
else
  amixer sset Master mute > /dev/null
fi
