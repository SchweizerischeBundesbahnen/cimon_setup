#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# configure the free sbb wlan access
setupdir=$(dirname $(readlink -f $0))/freesbb

echo "$(date) Starting Setup freesbb..."

# free sbb wlan auto connect (use wpa supplicant in order to allow reconnect)
echo "$(date) Installing network config files..."
sudo cp $setupdir/network/interfaces /etc/network/interfaces
sudo cp $setupdir/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
echo "$(date) Network config files installed"

echo "$(date) Restarting wlan0 and service networking..."
# restart wlan
sudo ifdown wlan0 > /dev/null 2>&1
sudo ifup wlan0 > /dev/null 2>&1
# and restart networking just to be sure
sudo service networking restart
echo "$(date) Wlan0 and service networking restarted"

echo "$(date) Installing the freesbb script and chronjob..."
# script to click the accept (gratis ins internet) button
sudo mkdir -p /opt/cimon 2> /dev/null
sudo chmod a+rwx /opt/cimon 2> /dev/null
mkdir -p /opt/cimon/freesbb
cp $setupdir/src/*.py /opt/cimon/freesbb/
sudo cp $setupdir/cron.d/freesbb /etc/cron.d/freesbb
sudo chmod g-x,o-x /etc/cron.d/freesbb
echo "$(date) Freesbb script and chronjob installed"

echo "$(date) Running the freesbb script..."
# try connect to freesbb
python3 /opt/cimon/freesbb/freesbb.py > /dev/null
if [[ $? -ne 0 ]]; then
    echo "$(date) Run freesbb script termninated in ERROR"
    exit 33
fi
echo "$(date) Freesbb script run"

echo "$(date) Setup terminated OK."
# check it was installed
ls /opt/cimon/freesbb > /dev/null