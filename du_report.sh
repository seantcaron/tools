#!/bin/bash

REPORT_FILE=`tempfile -p disku`

EMAIL_DEST="scaron@umich.edu"
MOUNTS="/usr /var"
HOST=`hostname`

MONTH=`date | cut -d " " -f 2`
YEAR=`date | cut -d " " -f 7`

echo $REPORT_FILE

printf "*** $MONTH $YEAR Disk Utilization Report for $HOST ***\n\n" >> $REPORT_FILE

printf "*** Overall Picture ***\n\n" >> $REPORT_FILE

df -klh $MOUNTS >> $REPORT_FILE

printf "\n\n" >> $REPORT_FILE

for mount in $MOUNTS; do
  printf "*** Disk utilization breakdown for /net/$HOST$mount ***\n\n" >> $REPORT_FILE

  du -sh $mount/* | sort -rh | grep -v "^0" >> $REPORT_FILE

  printf "\n\n" >> $REPORT_FILE
done

cat $REPORT_FILE | mail -s "$month $year Disk Utilization Report for $HOST" -c $EMAIL_DEST

rm $REPORT_FILE
