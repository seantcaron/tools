#!/bin/bash

# Identify and block subnets targeting a specific service with a trivial DDoS attack
# Arguments:
#    port: TCP port number of targeted service

# Find problem IPs with:
#  netstat -an | grep <PORT> | tr -s ' ' | cut -d ' ' -f 5 | cut -d ':' -f 1 | sort
# Dereference to subnets with:
#  whois <IP> | grep -v mnt-route | grep route | tr -s ' ' | cut -d ' ' -f 2
# Run this output through uniq and then block each result with iptables

# Check command line arguments
if [ -z "$1" ]; then
    echo "Usage: $0 [port]"
    exit
fi

port=$1
tempfile=`tempfile`

# Identify IPs connecting to the targeted service
for ip in `netstat -an | grep $port | grep -v LISTEN | tr -s ' ' | cut -d ' ' -f 5 | cut -d ':' -f 1 | sort`; do
    # Use whois to dereference these to the subnets to which they belong
    whois $ip | grep -v ^mnt-route | grep ^route | tr -s ' ' | cut -d ' ' -f 2 >> $tempfile
done

# Block each problem subnet using iptables
for subnet in `cat $tempfile | uniq`; do
    iptables -A INPUT -s $subnet -j DROP
done

rm $tempfile
