#!/usr/bin/python3

#
# Deduplicate lines in a text file
#

import sys

if len(sys.argv) != 2:
    print("Usage: " + sys.argv[0] + " [file]")
    sys.exit(1)

unique_lines = [ ]

try:
    f = open(sys.argv[1], "r")
except FileNotFoundError:
    print("File not found")
    sys.exit(1)

for line in f:
    if line.rstrip('\n') not in unique_lines:
        unique_lines.append(line.rstrip('\n'))

for line in unique_lines:
    print(line)

f.close()
