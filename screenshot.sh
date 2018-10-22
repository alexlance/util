#!/bin/bash


p="/home/alla/Download/screenshot/"
scrot "${p}%Y-%m-%d_%H:%M:%S.png"
f=${p}$(ls ${p} -t | head -1)
ratpoison -c "echo ${f}"
echo $f | xclip -i -selection clipboard -f | xclip -i -selection primary
gimp $f &
