#!/bin/bash
#echo $(/usr/bin/sensors | grep Core | awk '{print $3}' | egrep -o '[0-9\.]*')

batt=$(acpi -b | grep -o -E '[0-9]*%')

cpu=$(acpi -t -B | grep -o -E [0-9]{2})

for i in $cpu; do 
  let x=x+i;
done;

echo $(($x/3))c $batt;


#cpu=$(acpi -t -B | grep -o -E [0-9]+.[0-9]+)
#echo ${cpu//.0/} $batt;

