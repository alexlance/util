#!/bin/bash -x

# Hit homeassistant and cycle the lights forwards and back

if [ "${1}" == "back" ]; then
  curl -sL -X POST http://pi.lan:8123/api/webhook/magicbuttonback
else
  curl -sL -X POST http://pi.lan:8123/api/webhook/magicbutton
fi
# ratpoison -c "echo cheese!"
