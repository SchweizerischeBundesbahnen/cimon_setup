#!/usr/bin/env bash
# configure the free sbb wlan access
setupdir=$(dirname $(readlink -f $0))/freesbb
#
#
# free sbb wlan auto connect (use wpa supplicant in order to allow reconnect)
sudo cp $setupdir/network/interfaces /etc/network/interfaces
sudo cp $setupdir/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
# restart wlan
sudo ifdown wlan0 > /dev/null 2>&1
sudo ifup wlan0 > /dev/null 2>&1
# and restart networking just to be sure
sudo service networking restart
#
# script to click the accept (gratis ins internet) button
sudo mkdir -p /opt/cimon 2> /dev/null
sudo chmod a+rwx /opt/cimon 2> /dev/null
mkdir -p /opt/cimon/freesbb
cp $setupdir/src/*.py /opt/cimon/freesbb/
sudo cp $setupdir/cron.d/freesbb /etc/cron.d/freesbb
sudo chmod g-x,o-x /etc/cron.d/freesbb
#
# try connect to freesbb
python3 /opt/cimon/freesbb/freesbb.py > /dev/null
