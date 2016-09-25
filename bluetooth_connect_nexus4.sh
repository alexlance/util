#!/bin/bash

[ "$(id -u)" != 0 ] && echo "must run as root" && exit 1

# need to run a one off association:
#    bluez-simple-agent 
#    enter a pin
#    run pand connect
#    enter pin
#    get everything associated
#    kill everything /etc/init.d/bluetooth stop and pand -K

# and then just run this:
# (hcitool scan to find the bluetooth device, make sure it's discoverable!)
pand --connect 10:68:3F:27:6E:A9 -n
ifdown wlan0
dhclient bnep0

# and pand -K to halt
# /etc/init.d/bluetooth stop
