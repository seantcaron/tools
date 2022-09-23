#!/bin/bash

# Locate all drives that are not already part of an MD array
# Sean Caron <scaron@umich.edu>

# Run this script like:
#  ./mdfindunused.sh <uuid_of_array>

IFS=$'\n'

for line in `/usr/bin/lsscsi | /bin/grep /dev/ | /bin/grep -Ev 'PERC|Dell|DELL|HP|LSI|DVD|Virtual|enclosu'`; do
    # Number of fields can vary so be sure to always grab the last possible field (device name)
    field_ct=`echo $line | /usr/bin/tr -s ' ' | /usr/bin/awk -F ' ' '{print NF; exit}'`
    drive=`echo $line | /usr/bin/tr -s ' ' | /usr/bin/cut -f $field_ct -d ' '`
    
    grep `basename $drive`\\[ /proc/mdstat &>/dev/null

    if [ $? != 0 ]; then
        echo $drive
    fi
done

