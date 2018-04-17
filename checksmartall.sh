#!/bin/bash

for drive in /dev/sd[f-z] /dev/sd[a-z][a-z] ; do
    smartctl -a $drive | grep result
done

