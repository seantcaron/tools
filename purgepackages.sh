#!/bin/bash

for i in $(cat $1) ; do
    apt-get -y --force-yes purge $i
done
