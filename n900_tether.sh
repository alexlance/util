#!/bin/bash

# 1. turn bluetooth on n900,
# 2. disable all other connections on leaf and n900
# 3. run this script
# if it didn't work run it again.

#sdptool search --bdaddr C0:38:F9:A6:2C:6A DUN
#rfcomm release /dev/rfcomm0
#rfcomm bind /dev/rfcomm0 C0:38:F9:A6:2C:6A 1

# replace the following with the MAC address of your phone. Note that
# your phone does NOT need to be discoverable for this to work.
BT=C0:38:F9:A6:2C:6A
if test "$(id -u)" -ne 0 ; then
        exec sudo $0
fi
CHAN=$(sdptool search --bdaddr $BT DUN | awk '/Channel/ { print $2}')
rfcomm release /dev/rfcomm0
rfcomm bind /dev/rfcomm0 "$BT" "$CHAN"
rfcomm

wvdial cellular
