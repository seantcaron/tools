#!/usr/bin/python3

og_dict = dict()
bk_dict = dict()

# Read in the checksum output from the backup copies
f = open("bkup_results.sorted.cleaned", "r")
for x in f:
  # Split filename and sha1sum
  bkup_hash, bkup_filename = x.split('  ')
  # Normalize the path relative to /net/giant-glgc/disk1
  bk_base_filename = bkup_filename[45:]
  # Remove newline
  bk_base_filename = bk_base_filename.strip()

  bk_dict[bk_base_filename] = bkup_hash

# Read in the checksum output from the original source
g = open("og_results.sorted.cleaned", "r")
for y in g:
  # Split filename and sha1sum
  og_hash, og_filename = y.split('  ')
  # Normalize the path relative to /net/giant-glgc/disk1
  og_base_filename = og_filename[22:]
  # Remove newline
  og_base_filename = og_base_filename.strip()

  og_dict[og_base_filename] = og_hash

# For each original file
for key in og_dict:
  try:
    # Check to see if the file exists in the backup dictionary and the checksums match
    if og_dict[key] == bk_dict[key]:
        print("File " + key + " checksums PASS\n")
    else:
        print("File " + key + " checksums FAIL\n")
  # File not found in backups
  except KeyError:
    print("File " + key + " NOT FOUND\n")
