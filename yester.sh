#!/bin/bash

# day="${1}"
# [ -z "${day}" ] && day=0
# if [ "${day}" = "0" ]; then 
#   folder="today"
# elif if [ "${day}" = "1" ]; then 
#   folder="yester"
# fi

folder="yester"
day=1

if [ -n "${folder}" ]; then

  rm /home/alla/Mail/${folder}/cur/*

  find /home/alla/Mail -mtime ${day} -type f -not -regex "/home/alla/Mail/today/.*" -not -regex '.*\.tar\.gpg$' -not -regex "/home/alla/Mail/sent-mail/.*" -not -regex "/home/alla/Mail/s/.*" -not -regex "/home/alla/Mail/spam-all/.*" -exec ln -s {} /home/alla/Mail/${folder}/cur/ \;

fi
