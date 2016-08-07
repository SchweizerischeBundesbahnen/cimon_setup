#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# install or update tart/stop script, watchdog script

SETUPDIR=$(dirname $(readlink -f $0))

pushd .

cd $SETUPDIR

git rev-parse --is-inside-work-tree  1>/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Not in a git repository dir $(pwd)"
    exit 81
fi

# if no version file (for instance new installation) or version has changed
if [[ ! -f /opt/cimon/watchdog/.version || $(cat /opt/cimon/watchdog/.version) != $(git rev-parse HEAD) ]]; then
    sudo cp $SETUPDIR/init.d/cimon.sh /etc/init.d
    sudo chmod a+x /etc/init.d/cimon.sh
    if [[ -f ~/cimon/.autostart_controller ]] && [[ "$(cat ~/cimon/.autostart_controller)" == "true" ]]; then
        sudo update-rc.d cimon.sh defaults
    else
        sudo update-rc.d cimon.sh disable
    fi
    sudo systemctl daemon-reload
    # install the check script
    mkdir -p /opt/cimon/watchdog
    cp $SETUPDIR/watchdog.sh /opt/cimon/watchdog/watchdog.sh
    sudo chmod a+x /opt/cimon/watchdog/watchdog.sh
    # cronjob for start/restart in case there is an issue
    sudo cp $SETUPDIR/cron.d/cimon /etc/cron.d/cimon
    sudo chmod g-x,o-x /etc/cron.d/cimon

    git rev-parse HEAD > /opt/cimon/watchdog/.version
fi

popd