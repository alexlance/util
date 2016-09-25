#!/bin/bash

export DISPLAY=:0

xmodmap /home/alla/xmods

# enable middle click emulation
# xinput list-props 9

#xinput set-prop 9 247 1
#xinput set-prop 9 248 300

#xinput set-prop 9 250 1
#xinput set-prop 9 251 300

#xinput set-prop 9 275 1
#xinput set-prop 9 276 300

#xinput set-prop 8 496 1
#xinput set-prop 8 497 300

xinput set-prop 9 254 1
xinput set-prop 9 255 300

# faster mouse emulation
xkbset ma 20 20 20 30 300

