#!/usr/bin/env bash
# install the update_config scripts
setupdir=$(dirname $(readlink -f $0))
sudo mkdir -p /opt/cimon > /dev/null 2>&1
sudo chmod a+rwx /opt/cimon > /dev/null 2>&1
mkdir -p /opt/cimon/autoupdate
cp -n $setupdir/autoupdate.sh /opt/cimon/autoupdate/autoupdate.sh
cp -n $setupdir/clone_or_pull_github.sh /opt/cimon/autoupdate/clone_or_pull_github.sh
chmod a+rx /opt/cimon/autoupdate/*.sh
sudo cp $setupdir/cron.d/autoupdate_cimon /etc/cron.d/autoupdate_cimon
sudo chmod g-x,o-x /etc/cron.d/autoupdate_cimon
# create folder on mydrive
mount /mnt/mydrive
mkdir -p /mnt/mydrive/config/$(hostname)
cp -n /mnt/mydrive/config/templates/cimon.yaml /mnt/mydrive/config/$(hostname)/cimon.yaml
umount /mnt/mydrive > /dev/null 2>&1
