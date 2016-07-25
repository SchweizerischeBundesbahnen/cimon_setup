#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# install the update_config scripts
SETUPDIR=$(dirname $(readlink -f $0))
mkdir -p /opt/cimon/autoupdate
cp -n $SETUPDIR/autoupdate.sh /opt/cimon/autoupdate/autoupdate.sh
cp -n $SETUPDIR/clone_or_pull_github.sh /opt/cimon/autoupdate/clone_or_pull_github.sh
chmod a+rx /opt/cimon/autoupdate/*.sh
sudo cp $SETUPDIR/cron.d/autoupdate_cimon /etc/cron.d/autoupdate_cimon
sudo chmod g-x,o-x /etc/cron.d/autoupdate_cimon