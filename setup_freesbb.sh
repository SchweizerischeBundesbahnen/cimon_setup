#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# configure the free sbb wlan access
CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "$(date) Setup freesbb terminated in ERROR"
        popd
        exit $RC
    fi
}

SETUPDIR=$(dirname $(readlink -f $0))/freesbb

echo "$(date) Starting Setup freesbb..."

echo "$(date) Creating the /opt/cimon dir if required..."
bash $SETUPDIR/create_cimon_dir.sh
echo "$(date) Cimon dir created"

# free sbb wlan auto connect (use wpa supplicant in order to allow reconnect)
echo "$(date) Installing network config files..."
if [ "$(cat /etc/os-release | grep jessy)" != "" ]; then
    sudo cp $SETUPDIR/network/interfaces_jessy /etc/network/interfaces
else
    sudo cp $SETUPDIR/network/interfaces /etc/network/interfaces
fi
sudo cp $SETUPDIR/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
echo "$(date) Network config files installed"

echo "$(date) Reconfiguring wlan0..."
sudo wpa_cli -i wlan0 reconfigure
sleep 5
echo "$(date) Wlan0 reconfigured"

# install the script and cronjob
bash $SETUPDIR/update_freesbb.sh

echo "$(date) Running the freesbb script after 15 seconds rest..."
sleep 15
# try connect to freesbb
python3 /opt/cimon/freesbb/freesbb.py > /dev/null
if [[ $? -ne 0 ]]; then

    echo "--------------------------------------------------------------------------------------------------------------"
    echo "$(date) Freesbb script failed, result is $?"
    echo "The most likely reason for this failure is that a reboot is needed to reconfigure the interfaces."
    echo "If you see this message again after a reboot, press Ctrl+C, manually enable the WIFI and restart the installation script."
    echo "--------------------------------------------------------------------------------------------------------------"

    read -n1 -rsp $'Press enter to reboot or Ctrl+C to exit...\n'
    sudo shutdown -r now
else
    echo "$(date) Freesbb script run, result is $?"
fi

echo "$(date) Setup freesbb terminated OK."
# check it was installed
ls /opt/cimon/freesbb > /dev/null
