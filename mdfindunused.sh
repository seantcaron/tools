#!/bin/bash

# Locate all drives that are not already part of an MD array
# Sean Caron <scaron@umich.edu>

# Run this script like:
#  ./mdfindunused.sh <uuid_of_array>

for drive in /dev/sd[b-z] /dev/sd[a-z][a-z] ; do
    grep `basename $drive` /proc/mdstat &>/dev/null

    if [ $? != 0 ]; then
        echo $drive
    fi
done

