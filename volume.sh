#!/bin/bash

if [ "$1" = "up" ]; then
  amixer set Master 3000+ > /dev/null
elif [ "$1" = "down" ]; then
  amixer set Master 3000- > /dev/null
fi

