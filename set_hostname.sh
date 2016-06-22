#!/usr/bin/env bash
# Set the hostname
# stolen from https://wiki.debian.org/HowTo/ChangeHostname
usage() {
   echo "usage : $0 <new hostname>"
   exit 1
}

[ "$1" ] || usage

old=$(hostname)
new=$1

grep "$old" /etc/ -rl 2>/dev/null |
while read file
do
      sed "s:$old:$new:g" "$file" > "$file.tmp"
      mv -f "$file.tmp" "$file"
done
