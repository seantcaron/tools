#!/bin/bash

# Locate all member drives of an MD array given the UUID of the array
# Sean Caron <scaron@umich.edu>

# Run this script like:
#  ./mdfinddrives.sh <uuid_of_array>

for drive in /dev/sd[b-z] /dev/sd[a-z][a-z] ; do
    mdadm --examine $drive | grep $1 &>/dev/null

    if [ $? == 0 ]; then
        echo $drive
    fi
done

