#!/bin/bash

#
# Output will be of the format:
# [device name] [array] [SMART overall status] [raw read error rt] [reallocated sector ct] [reallocated event ct] [current pending] [offline uncorrectable] [udma crc error ct]
#

IFS=$'\n'

for line in `/usr/bin/lsscsi | /bin/grep /dev/ | /bin/grep -Ev 'PERC|Dell|DELL|HP|LSI|DVD|Virtual|enclosu'`; do
    # Number of fields can vary so be sure to always grab the last possible field (device name)
    field_ct=`echo $line | /usr/bin/tr -s ' ' | /usr/bin/awk -F ' ' '{print NF; exit}'`
    drive=`echo $line | /usr/bin/tr -s ' ' | /usr/bin/cut -f $field_ct -d ' '`
    
    # Member of md array
    if mdadm --examine $drive > /dev/null 2>&1; then
        { echo $drive | tr '\n' ' ';
        mdadm --examine $drive | grep Name | awk '{$1=$1};1' | cut -d ' ' -f 3 | cut -d ':' -f 2 | sed -e 's/^/\/dev\/md/' | tr '\n' ' ';
        smartctl -H $drive | grep overall-health | cut -d ' ' -f 6 | tr '\n' ' ';
        smartctl -A $drive | grep '^  1\|^  5\|^196\|^197\|^198\|^199' | tr -s ' ' | awk '{$1=$1};1' | cut -d ' ' -f 10 | tr '\n' ' ';
        echo; } | cat >> output
    # Not member of md array
    else
        { echo $drive | tr '\n' ' ';
        echo "NONE" | tr '\n' ' ';
        smartctl -H $drive | grep overall-health | cut -d ' ' -f 6 | tr '\n' ' ';
        smartctl -A $drive | grep '^  1\|^  5\|^196\|^197\|^198\|^199' | tr -s ' ' | awk '{$1=$1};1' | cut -d ' ' -f 10 | tr '\n' ' ';
        echo; } | cat >> output
    fi
done
