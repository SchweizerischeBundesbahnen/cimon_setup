#!/usr/bin/env bash
# taken from http://www.cyberciti.biz/tips/shell-script-to-watch-the-disk-space.html
# send an mail if there is more than 90% of the disk space is full

if ! [[ -f ~/cimon/.mailto ]]; then
    echo "No mailto address defined"
    exit 0
fi

df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 90 ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" |
    echo -e "$(df)" | mail -s "CIMON $(hostname): Almost out of disk space $usep%" $(cat ~/cimon/.mailto)
  fi
done