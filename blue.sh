#!/bin/bash
set -euxo pipefail

# bt-adapter -d to show devices
#echo "trust $mac" | bluetoothctl
#echo "pair $mac" | bluetoothctl

# this works: pactl set-sink-volume bluez_sink.2C_41_A1_15_2F_8B.a2dp_sink +30%

cat <<EOF> /etc/asound.conf
  # the bluetooth speaker number as displayed by `pactl list cards short`
  defaults.pcm.device 2
  defaults.pcm.card 1
  defaults.ctl.card 1
EOF

mac="2C:41:A1:15:2F:8B"
echo "connect $mac" | bluetoothctl
