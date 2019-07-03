#!/usr/bin/env bash
# Set the hostname
# copied from https://wiki.debian.org/HowTo/ChangeHostname
usage() {
   echo "usage : $0 <new hostname>"
   exit 1
}

[ "$1" ] || usage

old=$(hostname)
new=$1

sed "s:$old:$new:g" /etc/hosts > /etc/hosts.tmp
mv -f /etc/hosts.tmp /etc/hosts

sed "s:$old:$new:g" /etc/hostname > /etc/hostname.tmp
mv -f /etc/hostname.tmp /etc/hostname
