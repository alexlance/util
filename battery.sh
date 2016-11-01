#!/bin/bash

b="$(acpi -b | grep -oE '[0-9]+%')"
echo $b


n="$(acpi -b | grep -i discharging | grep -oE '[0-9]+%' | grep -oE '[0-9]+')"

[ "${n}" ] && [ "${n}" -lt 7 ] && ratpoison -c "echo battery ${b}"
[ "${n}" ] && [ "${n}" -lt 4 ] && mplayer /home/alla/bin/battery.mp3
