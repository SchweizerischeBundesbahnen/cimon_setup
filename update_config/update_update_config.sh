#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016

SETUPDIR=$(dirname $(readlink -f $0))

# if no version file (for instance new installation) or version has changed
if [[ ! -f /opt/cimon/update_config/version || $(cat /opt/cimon/update_config/version) != $(git rev-parse HEAD) ]]; then
    $SETUPDIR/install_update_config.sh
    echo "$(date) installed new version $(git rev-parse HEAD) to /opt/cimon/update_config"
fi
# else, nothing to do (current version allready installed)
