#!/bin/bash

EMAIL_DEST="scaron@umich.edu"
MOUNTS="/usr /var"

HOST=`hostname`
REPORT_FILE=`tempfile -p disku`

MONTH=`date | cut -d " " -f 2`
YEAR=`date | cut -d " " -f 7`

printf "*** $MONTH $YEAR Disk Utilization Report for $HOST ***\n\n" >> $REPORT_FILE

printf "*** Overall Picture ***\n\n" >> $REPORT_FILE

# Print df header
df -klh $MOUNTS | head -1 >> $REPORT_FILE

# Print df output
df -klh $MOUNTS | tail +2 | sort | uniq >> $REPORT_FILE

printf "\n\n" >> $REPORT_FILE

# Print detailed du output for each configured mount
for mount in $MOUNTS; do
  EXCLUDES=""

  # Exclude mountpoints because they do not compose utilization of the filesystem that
  #  we are currently reporting on
  for object in $mount/*; do
    mountpoint -q $object > /dev/null

    # If the item is a mountpoint then add it to our list of excludes
    if [ $? == 0 ]; then
      EXCLUDES="$EXCLUDES --exclude=`basename $object`"
    fi
  done

  echo $EXCLUDES

  printf "*** Disk utilization breakdown for $mount ***\n\n" >> $REPORT_FILE

  du -sh $EXCLUDES $mount/* | sort -rh | grep -v "^0" >> $REPORT_FILE

  printf "\n\n" >> $REPORT_FILE
done

# Send report via email to configured recipients
cat $REPORT_FILE | mail -s "$month $year Disk Utilization Report for $HOST" -c $EMAIL_DEST

rm $REPORT_FILE
