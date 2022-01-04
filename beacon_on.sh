#!/bin/bash
for drive in `lsscsi|grep -v PERC|grep -v DVD|tr -s ' '| cut -f 7 -d ' '` ; do
    ./beacon `basename $drive` on
done

