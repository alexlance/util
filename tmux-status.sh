#!/bin/bash

ipa="$(curl -s https://alexlance.com/ip)"
[[ "${ipa}" =~ "103."* ]] && echo -n "[VPN] "

swap=$(free --mega | grep Swap | awk '{print $3}')
[ "${swap}" -ne "0" ] && echo -n "${swap}mb "

b="$(acpi -b 2>/dev/null | grep -oE '[0-9]+%')"
[ "${b}" ] && echo -n $b

n="$(acpi -b 2>/dev/null | grep -i discharging | grep -oE '[0-9]+%' | grep -oE '[0-9]+')"
[ "${n}" ] && [ "${n}" -lt 7 ] && ratpoison -c "echo battery ${b}"
[ "${n}" ] && [ "${n}" -lt 4 ] && mplayer /home/alla/bin/battery.mp3
