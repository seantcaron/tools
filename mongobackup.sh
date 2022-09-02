#!/bin/bash

#
# Usage:
#  ./mongobackup [destination directory]
#

BACKUPS_TO_KEEP=5
BACKUP_NAME_BASE="mongodb"
BACKUP_INDEX_NAME="backup_index.txt"

# Check command line arguments
if [ -z "$1" ]; then
    echo "Usage: $0 [destination directory]"
    exit
fi

# Backup root directory
bk_root=$1

# Current date
dt=`/bin/date --iso-8601`

# Basename of output directory for backup
outdir=$BACKUP_NAME_BASE.$dt

# Full path of output directory for backup
dest=$bk_root/$outdir

# Full path to backup index file
idx=$bk_root/$BACKUP_INDEX_NAME

#
# If the index file exists there must be prior backups. Check to see if we have hit the limit of
# backups to keep
#
if [ -f $idx ]; then
    # Determine number of backups we have recorded
    num_bks=`/usr/bin/wc -l $idx | /usr/bin/cut -d ' ' -f 1`

    # If that is our limit of backups to keep, delete the oldest backup and rotate the index file
    if [ $num_bks -eq $BACKUPS_TO_KEEP ]; then
        # Delete oldest backup
        bk_to_del=`/usr/bin/head -1 $idx | /usr/bin/cut -d ' ' -f 2`
        /bin/rm -rf $bk_root/$bk_to_del

        # Rotate index file
        lines_to_kp=$(($BACKUPS_TO_KEEP-1))
        /usr/bin/tail -$lines_to_kp $idx > $idx.new
        /bin/rm -f $idx
        /bin/mv $idx.new $idx
    fi
fi

# Add this backup to the index file
echo $dt $outdir >> $idx

# Run the MongoDB backup to the destination directory
/usr/bin/mongodump --quiet --gzip --out=$dest
