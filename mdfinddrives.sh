#!/bin/bash

# Locate all member drives of an MD array given the UUID of the array
# Sean Caron <scaron@umich.edu>

# Run this script like:
#  ./mdfinddrives.sh <uuid_of_array>

i=0
array=`grep $1 /etc/mdadm/mdadm.conf | cut -d " " -f 2 | cut -d "/" -f 4`
cmd="mdadm --assemble --force /dev/md$array "

for drive in /dev/sd[b-z] /dev/sd[a-z][a-z] ; do
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
