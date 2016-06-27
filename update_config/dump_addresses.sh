#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# dump mac and ip address

if [[ ! -d $1 ]]; then
    echo "Missing or invalid parameter directory: $1"
fi
DIR=$1

# the current interface with the default route
IF=$(ip route show default | grep -Po '(?<=(dev )).*(?= proto)')
IF=${IF%"${IF##*[![:space:]]}"}

# fetch its mac address
MAC=$(ifconfig $IF | awk '/HWaddr/{print $5}')

# and its current IPv4 address
IP=$(ifconfig $IF | awk '/inet addr/{print substr($2,6)}')

# if changed, write the file address.txt in the format <interface> <mac_address> <ip_address>
if [[ ! -f $DIR/address.txt || ! "$IF $MAC $IP" == "$(cat $DIR/address.txt)" ]]; then
    echo "$IF $MAC $IP" > $DIR/address.txt
fi
