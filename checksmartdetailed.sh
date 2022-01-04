#!/bin/bash
for drive in `lsscsi|grep -v PERC|grep -v DVD|tr -s ' '| cut -f 7 -d ' '` ; do
    { echo $drive | tr '\n' ' '; smartctl -H $drive | grep overall-health | cut -d ' ' -f 6 | tr '\n' ' '; smartctl -A $drive | grep '^  1\|^  5\|^196\|^197\|^198\|^199' | tr -s ' ' | awk '{$1=$1};1' | cut -d ' ' -f 10 | tr '\n' ' '; echo; } | cat >> output
done
