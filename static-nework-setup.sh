#!/bin/bash 
set -x

dev=enxec2880a33b9b
ip addr add 192.168.1.22/24 dev $dev
ip link set $dev up
ip route add 192.168.1.0/24 via 192.168.1.22 dev $dev
ip route add default via 192.168.1.1
