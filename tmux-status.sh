#!/bin/bash

if /sbin/ifconfig | grep tun -A1 | grep -q 10.22.0; then
  echo -n "#[fg=red]◉#[fg=white] "
else
  echo -n "#[fg=grey]○#[fg=white] "
fi

if /sbin/ifconfig | grep tun -A1 | grep -q 10.19.0; then
  echo -n "#[fg=green]◉#[fg=white] "
else
  echo -n "#[fg=grey]○#[fg=white] "
fi

if curl -s https://alexlance.com/ip | grep -qE '^103.'; then
  echo -n "#[fg=yellow]◉#[fg=white]"
else
  echo -n "#[fg=grey]○#[fg=white]"
fi

echo -n " "

swap=$(free --mega | grep Swap | awk '{print $3}')
[ "${swap}" -ne "0" ] && echo -n "${swap}mb "
[ "${swap}" -gt 2000 ] && ratpoison -c "echo swap ${swap}mb"

if [ "$(hostname)" == "lyra" ]; then
  b="$(acpi -b 2>/dev/null | grep -oE '[0-9]+%')"
  [ "${b}" ] && echo -n $b

  n="$(acpi -b 2>/dev/null | grep -i discharging | grep -oE '[0-9]+%' | grep -oE '[0-9]+')"
  [ "${n}" ] && [ "${n}" -lt 7 ] && ratpoison -c "echo battery ${b}"
  [ "${n}" ] && [ "${n}" -lt 4 ] && mplayer /home/alla/bin/battery.mp3
fi

echo "#[fg=blue,bold]$(date '+%l:%M%P %Y-%m-%d %a')"
