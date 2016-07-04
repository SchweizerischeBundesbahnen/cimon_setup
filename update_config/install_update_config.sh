#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# install the update_config scripts
SETUPDIR=$(dirname $(readlink -f $0))
sudo mkdir -p /opt/cimon > /dev/null 2>&1
sudo chmod a+rwx /opt/cimon > /dev/null 2>&1
mkdir -p /opt/cimon/update_config
cp -f $SETUPDIR/update_config.sh /opt/cimon/update_config/update_config.sh
cp -f $SETUPDIR/dump_addresses.sh /opt/cimon/update_config/dump_addresses.sh
chmod a+rx /opt/cimon/update_config/*.sh
sudo cp -f $SETUPDIR/cron.d/update_config /etc/cron.d/update_config
sudo chmod g-x,o-x /etc/cron.d/update_config
git rev-parse --is-inside-work-tree 2> /dev/null
if [[ $? -eq 0 ]]; then
    git rev-parse HEAD > /opt/cimon/update_config/version
else
    rm -f /opt/cimon/update_config/version 2> /dev/null
fi