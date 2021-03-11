tools
-----

Sean Caron <scaron@umich.edu>

A collection of useful systems administration tools and scripts too small to justify their own repository.

#### addslurmusers.pl

Create a shell script to add a list of users back to the SLURM accounting system given a dump of the output of ```sacctmgr show user``` from a previous SLURM installation.

#### afsmigrate.pl

Given a list of AFS volumes, migrate them from source server and partition to destination server and partition.

#### beacon.go

Light error LEDs on drives in JBOD cabinets.

Build with:

```
go build beacon.go
```

#### beacon_off.sh

Deactivate error LED on all attached JBOD drives.

#### beacon_on.sh

Activate error LED on all attached JBOD drives.

#### check_ldap_server.py

Sentry script for slapd to ensure slapd is running, otherwise restart slapd.

#### checksmartall.sh

Dump SMART health status for all attached drives.

#### dnsseq.go

Automates the generation of long sequences of DNS A-records and PTR-records.

Build with:

```
go build dnsseq.go
```

#### pkgsinrepo.pl

Checks presence-in-repository status of all Package resources in a Puppet manifest.

#### mdfinddrives.sh

Find all drives that should be members of a given MD RAID array.

#### purgepackages.sh

Automatically purge a list of packages in Linux distributions that use apt style package management.

Input should be a file containing a list of packages, one package per line, prepped using a command similar to the following:

```
dpkg --get-selections | grep -v deinstall | cut -f 1 > purgepackages.list
```

#### pwgen.go

Generate random password strings.

Build with:

```
go build pwgen.go
```

#### requeueheldslurm.pl

Generate a shell script to release all jobs held in the SLURM queue stuck in job requeued in held state.

#### selections2manifest.pl

Convert a list of packages in ```dpkg --get-selections``` format to a basic list of Package resources in a Puppet manifest.

Input should be a file containing a list of packages, one package per line, prepped using a command similar to the following:

```
dpkg --get-selections | grep -v deinstall | cut -f 1 > input.selections
```

#### zerodrives.sh

Clear MD RAID superblock and zero a small initial extent of all attached JBOD drives.

