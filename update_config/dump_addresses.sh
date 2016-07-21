#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# dump mac and ip address
# warning: the awk and grep commands are copy-pasted from somewhere on the 

if [[ ! -d $1 ]]; then
    echo "Missing or invalid parameter directory: $1"
fi
DIR=$1

HN=$(hostname)

# the current interface with the default route
IF=$(ip route show default | grep -Po '(?<=(dev )).*(?= proto)')
IF=${IF%"${IF##*[![:space:]]}"} # it may have a trailing blank, remove

ADDRESS_TXT="$HN $(ifconfig $IF | head -n 3)"

# if changed, write the file address.txt in the format <hostname> <interface> <mac_address> <ip_address>
if [[ ! -f $DIR/address.txt || "$ADDRESS_TXT" != "$(cat $DIR/address.txt)" ]]; then
    echo "$ADDRESS_TXT" > $DIR/address.txt
    exit 1
fi
exit 0
