#!/bin/bash

if [ "$1" = "up" ]; then
  pulsemixer --change-volume +10
  ratpoison -c "echo $(pulsemixer --get-volume)"
else
  pulsemixer --change-volume -10
  ratpoison -c "echo $(pulsemixer --get-volume)"
fi
