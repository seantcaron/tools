#!/bin/bash
for drive in /dev/sdc /dev/sd[a-z][a-z] ; do
    ./beacon `basename $drive` off
done

