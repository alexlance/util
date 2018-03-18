#!/bin/bash

swap=$(free --mega | grep Swap | awk '{print $3}')

if [ "${swap}" -ne "0" ]; then
  echo "${swap}mb"
fi
