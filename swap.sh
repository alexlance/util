#!/bin/bash

swap=$(free | grep Swap | awk '{print $3}')

if [ "${swap}" -ne "0" ]; then
  echo "swap: ${swap}"
fi
