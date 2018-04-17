#!/bin/bash

for drive in /dev/sd[b-z] /dev/sd[a-z][a-z] ; do
    mdadm --zero-superblock $drive
    dd if=/dev/zero of=$drive bs=512 count=1024
done

