#!/bin/bash

# Locate all member drives of an MD array given the UUID of the array
# Sean Caron <scaron@umich.edu>

# Run this script like:
#  ./mdfinddrives.sh <uuid_of_array>

i=0
array=`grep $1 /etc/mdadm/mdadm.conf | cut -d " " -f 2 | cut -d "/" -f 4`
cmd="mdadm --assemble --force /dev/md$array "

IFS=$'\n'

for line in `/usr/bin/lsscsi | /bin/grep /dev/ | /bin/grep -Ev 'PERC|Dell|DELL|HP|LSI|DVD|Virtual|enclosu'`; do
    # Number of fields can vary so be sure to always grab the last possible field (device name)
    field_ct=`echo $line | /usr/bin/tr -s ' ' | /usr/bin/awk -F ' ' '{print NF; exit}'`
    drive=`echo $line | /usr/bin/tr -s ' ' | /usr/bin/cut -f $field_ct -d ' '`
    
    mdadm --examine $drive | grep $1 &> /dev/null

    if [ $? == 0 ]; then
        echo $drive
        i=$((i+1))
        cmd+=$drive
        cmd+=" "
    fi
done

echo "Found $i drives"

echo "Reconstruct the array with the command:"

echo $cmd
