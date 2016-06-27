#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# install the update_config scripts
setupdir=$(dirname $(readlink -f $0))
sudo mkdir -p /opt/cimon > /dev/null 2>&1
sudo chmod a+rwx /opt/cimon > /dev/null 2>&1
mkdir -p /opt/cimon/update_config
cp $setupdir/update_config.sh /opt/cimon/update_config/update_config.sh
cp $setupdir/dump_addresses.sh /opt/cimon/update_config/dump_addresses.sh
chmod a+rx /opt/cimon/update_config/*.sh
sudo cp $setupdir/cron.d/update_config /etc/cron.d/update_config
sudo chmod g-x,o-x /etc/cron.d/update_config
# create folder on mydrive
if [[ $1 ]]; then
    HN=$1
else
    HN=$(hostname)
fi
mount /mnt/mydrive
mkdir -p /mnt/mydrive/config
mkdir -p /mnt/mydrive/config/$HN
if [[ -f /mnt/mydrive/config/templates/cimon.yaml ]]; then
    cp -n /mnt/mydrive/config/templates/cimon.yaml /mnt/mydrive/config/$HN/cimon.yaml
fi
umount /mnt/mydrive > /dev/null 2>&1
