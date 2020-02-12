#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# monitoring cimon, do not monitoring configuration

SETUPDIR=$(dirname $(readlink -f $0))

CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "Update terminated in ERROR"
        exit $RC
    fi
}
echo "$(date) Update if required..."

# upgrade packages
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
CheckReturncode
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
CheckReturncode

if [[ -d /opt/cimon/update_config ]]; then
    # update the update config script
    bash $SETUPDIR/update_config/update_update_config.sh
    CheckReturncode
fi

bash $SETUPDIR/web/update_disable_screensleep.sh
CheckReturncode

bash $SETUPDIR/web/update_start_web_browser.sh
CheckReturncode

# update the monitoring (only on jessy, on newer raspbian systemd does that)
if [ "$(cat /etc/os-release | grep jessy)" != "" ]; then
    bash $SETUPDIR/monitoring/update_monitoring.sh
    CheckReturncode
fi

# update the start/stop script and watchdog script of the controller
bash $SETUPDIR/controller/update_start_stop_watchdog.sh
CheckReturncode

# update the controllerscripts
bash $SETUPDIR/controller/update_controller.sh
CheckReturncode

# update the freesbb
bash $SETUPDIR/freesbb/update_freesbb.sh
CheckReturncode

echo "$(date) Update terminated OK"
