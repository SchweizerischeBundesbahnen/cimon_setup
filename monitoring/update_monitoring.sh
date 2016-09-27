#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# install the monitoring scripts
SETUPDIR=$(dirname $(readlink -f $0))

pushd .

cd $SETUPDIR

git rev-parse --is-inside-work-tree  1>/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Not in a git repository dir $(pwd)"
    exit 87
fi

# if no version file (for instance new installation) or version has changed
if [[ ! -f /opt/cimon/monitoring/.version ]] || [[ $(cat /opt/cimon/monitoring/.version) != $(git rev-parse HEAD) ]]; then
    mkdir -p /opt/cimon/monitoring
    cp -f $SETUPDIR/dump_addresses.sh /opt/cimon/monitoring/dump_addresses.sh
    cp -f $SETUPDIR/mail_address.sh /opt/cimon/monitoring/mail_address.sh
    cp -f $SETUPDIR/mail_disk_full.sh /opt/cimon/monitoring/mail_disk_full.sh
    cp -f $SETUPDIR/mail_health.sh /opt/cimon/monitoring/mail_health.sh
    chmod a+rx /opt/cimon/monitoring/*.sh
    sudo cp -f $SETUPDIR/cron.d/monitoring /etc/cron.d/monitoring
    sudo chmod g-x,o-x /etc/cron.d/monitoring
    git rev-parse HEAD > /opt/cimon/monitoring/.version
fi

popd