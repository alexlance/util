#!/bin/bash

(cd /home/alla/scrot && scrot '%Y-%m-%d_%H:%M:%S.png')
f=/home/alla/scrot/$(ls /home/alla/scrot/ -t | head -1)
ratpoison -c "echo ${f}"
echo $f | xclip -i -selection clipboard -f | xclip -i -selection primary

