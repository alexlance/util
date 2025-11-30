#!/bin/bash

progress_bar() {
    local value=$1
    local max=149           # Max raw value that maps to 100%
    local width=40          # Width of the bar

    # Calculate normalized percentage (value/max * 100)
    local percent=$(( 100 * value / max ))

    # Clamp percent between 0 and 100 just in case
    (( percent < 0 )) && percent=0
    (( percent > 101 )) && percent=100

    local filled=$(( percent * width / 100 ))
    local empty=$(( width - filled ))

    printf ""
    printf "%0.s█" $(seq 1 $filled)
    printf "%0.s░" $(seq 1 $empty)
    printf " %3d%% %3d" "$percent" "$value"
    echo
}

pulsemixer --unmute
if [ "$1" = "up" ]; then
  pulsemixer --change-volume +10
else
  pulsemixer --change-volume -10
fi

avg=$(pulsemixer --get-volume | tr ' ' '\n' | awk '{ sum += $1; n++ } END { if (n>0) print sum/n }')
avg=$(progress_bar $avg)
ratpoison -c "echo  $avg"
