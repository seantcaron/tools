#!/bin/bash
for drive in `lsscsi|tr -s ' '| cut -f 7 -d ' '` ; do
    ./beacon `basename $drive` off
done

