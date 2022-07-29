#!/usr/bin/python3

#
# Check to see if OpenLDAP is running. If not, restart it and reset process limits.
#
# Install this script in cron as follows:
# *       *       *       *       *       /root/check_ldap_server.py
#

#
# Requires packages: python3-ldap
#

import ldap, os, sys, time

l = ldap.initialize('ldap://' + 'csgadmin.sph.umich.edu' + ':389')
try:
    l.simple_bind()
except:
    os.system('/etc/init.d/slapd restart 2>&1 > /dev/null')
    os.system('/usr/local/bin/change_limits $(pgrep slapd) 1000000 1000000 2>&1 > /dev/null')

    log = open('/var/log/check_ldap_server.log', 'a+')
    log_time = time.strftime("%A %b %d %H:%M:%S %Z", time.localtime())
    log.write(log_time + ': Restarted OpenLDAP server\n')
    log.close()

    sys.exit(0)

l.unbind()
