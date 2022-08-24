#!/usr/bin/python3

#
# Python Library Version Comparator (PLVC)
#  Sean Caron (scaron@umich.edu)
#
# This permits comparison of the installed version of a Python library (as reported by pip) with a version
# number specified on the command line
#
# Useful in Puppet onlyif and unless statements
#

import argparse,subprocess,sys

# Set up ArgumentParser
parser = argparse.ArgumentParser(description='Compare installed Python library version with specified version')

parser.add_argument('library',help='Library name')
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('-gt',metavar='VERSION',help='Greater than VERSION')
group.add_argument('-ge',metavar='VERSION',help='Greater than or equal to VERSION')
group.add_argument('-lt',metavar='VERSION',help='Less than VERSION')
group.add_argument('-le',metavar='VERSION',help='Less than or equal to VERSION')
group.add_argument('-eq',metavar='VERSION',help='Equal to VERSION')
group.add_argument('-ne',metavar='VERSION',help='Not equal to VERSION')

# Get command line arguments
args = parser.parse_args()

# Spawn an instance of pip to query the installed library version
process = subprocess.Popen(['python3','-m','pip','show',args.library],stdout=subprocess.PIPE,stderr=subprocess.PIPE)

# If the library is not installed, return 1 (Failure/FALSE)
if process.wait() != 0:
    sys.exit(1)

# Get the pip output
stdout, stderr = process.communicate()
output = stdout.decode()

# Parse out the installed version number from the pip output
lines = output.splitlines()
installed_ver = lines[1].split()

#
# Comparison operations
# Return 0 (Success/TRUE) if comparison is true, return 1 (Failure/FALSE) if comparison is false
#

if args.gt:
    # Check if installed version greater than specified version
    if installed_ver[1] > args.gt:
        sys.exit(0)
    else:
        sys.exit(1)
elif args.ge:
    # Check if installed version greater than or equal to specified version
    if installed_ver[1] > args.ge or installed_ver[1] == args.ge:
        sys.exit(0)
    else:
        sys.exit(1)
elif args.lt:
    # Check if installed version less than specified version
    if installed_ver[1] < args.lt:
        sys.exit(0)
    else:
        sys.exit(1)
elif args.le:
    # Check if installed version less than or equal to specified version
    if installed_ver[1] < args.le or installed_ver[1] == args.le:
        sys.exit(0)
    else:
        sys.exit(1)
elif args.eq:
    # Check if installed version equal to specified version
    if installed_ver[1] == args.eq:
        sys.exit(0)
    else:
        sys.exit(1)
elif args.ne:
    # Check if installed version not equal to specified version
    if installed_ver[1] != args.ne:
        sys.exit(0)
    else:
        sys.exit(1)
