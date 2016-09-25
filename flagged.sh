#!/bin/bash

# day="${1}"
# [ -z "${day}" ] && day=0
# if [ "${day}" = "0" ]; then 
#   folder="today"
# elif if [ "${day}" = "1" ]; then 
#   folder="yester"
# fi

folder="flagged"
day=0

if [ -n "${folder}" ]; then

  rm /home/alla/Mail/${folder}/cur/*

  find /home/alla/Mail -type f -not -regex '.*\.tar\.gpg$' -not -regex "/home/alla/Mail/sent-mail/.*" -not -regex "/home/alla/Mail/s/.*" -not -regex "/home/alla/Mail/spam-all/.*" -name "*,F*" -exec ln -sf {} /home/alla/Mail/${folder}/cur/ \;

fi
