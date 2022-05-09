#!/bin/bash

EMAIL_DEST="scaron@umich.edu"
MOUNTS="/usr /var"

HOST=`/bin/hostname`
REPORT_FILE=`/bin/tempfile -p disku`

MONTH=`/bin/date | /usr/bin/cut -d " " -f 2`
YEAR=`/bin/date | /usr/bin/cut -d " " -f 7`

/usr/bin/printf "*** $MONTH $YEAR Disk Utilization Report for $HOST ***\n\n" >> $REPORT_FILE

/usr/bin/printf "*** Overall Picture ***\n\n" >> $REPORT_FILE

# Print df header
/bin/df -klh $MOUNTS | /usr/bin/head -1 >> $REPORT_FILE

# Print df output
/bin/df -klh $MOUNTS | /usr/bin/tail +2 | /urs/bin/sort | /usr/bin/uniq >> $REPORT_FILE

/usr/bin/printf "\n\n" >> $REPORT_FILE

# Print detailed du output for each configured mount
for mount in $MOUNTS; do
  EXCLUDES=""

  # Exclude mountpoints because they do not compose utilization of the filesystem that
  #  we are currently reporting on
  for object in $mount/*; do
    /bin/mountpoint -q $object > /dev/null

    # If the item is a mountpoint then add it to our list of excludes
    if [ $? == 0 ]; then
      EXCLUDES="$EXCLUDES --exclude=`basename $object`"
    fi
  done
  
  /usr/bin/printf "*** Disk utilization breakdown for $mount ***\n\n" >> $REPORT_FILE

  /usr/bin/du -sh $EXCLUDES $mount/* | /usr/bin/sort -rh | /bin/grep -v "^0" >> $REPORT_FILE

  /usr/bin/printf "\n\n" >> $REPORT_FILE
done

# Send report via email to configured recipients
/bin/cat $REPORT_FILE | /usr/bin/mail -s "$month $year Disk Utilization Report for $HOST" -c $EMAIL_DEST

/bin/rm $REPORT_FILE
