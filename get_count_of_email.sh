#!/bin/bash

echo $(date '+%A %d %b %I:%M%p');

for i in ~/Mail/*; do 
  folder=$(basename $i);
  if [ -d "$i/new" ] && [ "${folder}" != "s" ] && [ "${folder:0:4}" != "spam" ] ; then 
    count=$(ls $i/new/ | wc -l); 
    [ "${count}" -gt 0 ] && echo "$folder $count"; 
  fi;
done;

