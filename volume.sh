#!/bin/bash

if [ "$1" = "up" ]; then
  pulsemixer --change-volume +10
else
  pulsemixer --change-volume -10
fi
