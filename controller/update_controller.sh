#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016

SETUPDIR=$(dirname $(readlink -f $0))

pushd .

# checkout newest version from GIT
bash $SETUPDIR/../autoupdate/clone_or_pull_github.sh /tmp/cimon_github cimon_controller

cd /tmp/cimon_github/cimon_controller

# if no version file (for instance new installation) or version has changed
if [[ ! -f /opt/cimon/controller/.version || $(cat /opt/cimon/controller/.version) != $(git rev-parse HEAD) ]]; then
    # create dir in case it does not exist
    mkdir -p /opt/cimon/controller  1>/dev/null 2>&1
    # install the python scripts
    cp /tmp/cimon_github/cimon_controller/src/* /opt/cimon/controller/
    # write version file
    git rev-parse HEAD > /opt/cimon/controller/.version
    echo "$(date) installed new version $(git rev-parse HEAD) to /opt/cimon/controller"
    if [[ -f ~/cimon/.autostart_controller ]] && [[ "$(cat ~/cimon/.autostart_controller)" == "true" ]]; then
        sudo service cimon restart
        echo "$(date) restarted service"
    fi
else
    echo "$(date) no new version of cimon_controller found."
fi
# else, nothing to do (current version allready installed)
popd