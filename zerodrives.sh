#!/bin/bash

IFS=$'\n'

for line in `/usr/bin/lsscsi | /bin/grep /dev/ | /bin/grep -Ev 'PERC|Dell|DELL|HP|LSI|DVD|Virtual|enclosu'`; do
    # Number of fields can vary so be sure to always grab the last possible field (device name)
    field_ct=`echo $line | /usr/bin/tr -s ' ' | /usr/bin/awk -F ' ' '{print NF; exit}'`
    drive=`echo $line | /usr/bin/tr -s ' ' | /usr/bin/cut -f $field_ct -d ' '`
    
    mdadm --zero-superblock $drive
    dd if=/dev/zero of=$drive bs=512 count=1024
done

