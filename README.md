tools
-----

Sean Caron <scaron@umich.edu>

A collection of useful systems administration tools and scripts too small to justify their own repository.

#### beacon.go

Light error LEDs on drives in JBOD cabinets.

#### beacon_off.sh

Deactivate error LED on all attached JBOD drives.

#### beacon_on.sh

Activate error LED on all attached JBOD drives.

#### checksmartall.sh

Dump SMART health status for all attached drives.

#### dnsseq.go

Automates the generation of long sequences of DNS A-records and PTR-records.

#### pkgsinrepo.pl

Checks presence-in-repository status of all Package resources in a Puppet manifest.

#### mdfinddrives.sh

Find all drives that should be members of a given MD RAID array.

#### purgepackages.sh

Automatically purge a list of packages in Linux distributions that use apt/aptitude.

Prep input with the following sequence of commands:

```
dpkg --get-selections | grep -v deinstall | cut -f 1 > purgepackages.list
```

#### pwgen.go

Generate random password strings.

#### selections2manifest.go

Convert a list of packages in ```dpkg --get-selections``` format to a basic list of Package resources in a Puppet manifest.

Prep input using the following sequence of commands:

```
dpkg --get-selections | grep -v deinstall | cut -f 1 > input.selections
```

#### zerodrives.sh

Clear MD RAID superblock and zero a small initial extent of all attached JBOD drives.

