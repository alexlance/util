#!/bin/bash -x

# apt-get install python-setuptools python-dev
# easy_install ouimeaux
# wemo server
# curl -X POST http://localhost:5000/api/device/heater



if [ "$(pgrep wemo)" = "" ]; then
  wemo server > /dev/null 2>&1 &
  sleep 5
fi


on="$(curl -s -X GET http://localhost:5000/api/device/heater | grep state.*1)"

function toggle() {
  mplayer /home/alla/bin/click.mp3
  curl -s -X POST http://localhost:5000/api/device/heater
}

if [ -z "${1}" ]; then
  toggle
  if [ "${on}" ]; then
    ratpoison -c "echo heater off"
    banner off
  else
    ratpoison -c "echo heater on"
    banner on
  fi

elif [ "$1" == "off" ] && [ "${on}" ]; then
  toggle
  ratpoison -c "echo heater off"
  banner off

elif [ "$1" == "on" ] && [ -z "${on}" ]; then
  toggle
  ratpoison -c "echo heater on"
  banner on
fi
