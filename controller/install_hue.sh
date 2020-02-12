#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2020
# setup hue including dhcp server
SETUPDIR=$(dirname $(readlink -f $0))

# setup dhcp sever on ethernet port in order to connect the hue bridge
DHCPCONF=/etc/dhcp/dhcpd.conf
sudo mv $DHCPCONF $DHCPCONF.orig
sudo cp -f $SETUPDIR/dhcp/dhcpd.conf $DHCPCONF
sudo chown root $DHCPCONF
sudo chmod u=rw,g=r,o=r $DHCPCONF

# setup eth0 as static IP
ETH0=/etc/network/interfaces.d/eth0
sudo cp -f $SETUPDIR/network/interfaces.d/eth0 $ETH0
sudo chown root $ETH0
sudo chmod u=rw,g=r,o=r $ETH0

# phue
sudo pip3 install phue