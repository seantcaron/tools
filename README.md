# tools

A collection of useful tools and scripts too small to justify their own repository.

## beacon.go

Light error LEDs on all drives in attached JBOD cabinets.

## beacon_off.sh

Deactivate error LED on all attached JBOD drives.

## beacon_on.sh

Activate error LED on all attached JBOD drives.

## checksmartall.sh

Dump SMART health status for all attached drives.

## dnsseq.go

Automates the generation of long sequences of DNS records.

## inmanifest.pl

Checks presence-in-repository status of all Package resources in a Puppet manifest.

## mdfinddrives.sh

Find all drives that should be members of a given MD RAID array.

## purgepackages.sh

Automatically purge a list of packages in Linux distributions that use apt/aptitude.

## pwgen.go

Generate random password strings.

## selections2manifest.go

Convert a list of packages in dpkg --get-selections format to a basic list of Package resources in a Puppet manifest.

## zerodrives.sh

Clear MD RAID superblock and zero a small initial extent of all attached JBOD drives.

