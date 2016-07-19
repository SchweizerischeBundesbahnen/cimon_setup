#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# update_config cimon, do not update_config configuration

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
    bash $SETUPDIR/update_config/install_or_update_update_config.sh
    CheckReturncode
fi

if [[ -d /opt/cimon/web ]]; then
    # update the webpage
    bash $SETUPDIR/web/update_web.sh
    CheckReturncode
fi

# update_config the controllerscripts
bash $SETUPDIR/controller/update_controller.sh
CheckReturncode

echo "$(date) Update terminated OK"
