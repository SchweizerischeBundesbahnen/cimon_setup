#!/usr/bin/env bash
# taken from http://www.cyberciti.biz/tips/shell-script-to-watch-the-disk-space.html
# send an mail if there is more than 90% of the disk space is full
MYDIR=$(dirname $(readlink -f $0))

df -H | grep -vE '^Filesystem|Dateisystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 90 ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" |
    echo -e "$(df -H)" | bash $MYDIR/send_mail.sh "CIMON $(hostname): Almost out of disk space $usep%"
  fi
done