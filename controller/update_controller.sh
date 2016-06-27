#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016

setupdir=$(dirname $(readlink -f $0))

# checkout newest version from GIT
bash $setupdir/../autoupdate/clone_or_pull_github.sh /tmp/cimon_github cimon_controller

cd /tmp/cimon_github/cimon_controller

# if no version file (for instance new installation) or version has changed
if [[ ! -f /opt/cimon/controller/version.txt || $(cat /opt/cimon/controller/version.txt) != $(git rev-parse HEAD) ]]; then
    # create dir in case it does not exist
    sudo mkdir -p /opt/cimon 2> /dev/null
    sudo chmod a+rwx /opt/cimon 2> /dev/null
    mkdir -p /opt/cimon/controller 2> /dev/null
    # install the python scripts
    cp /tmp/cimon_github/cimon_controller/src/* /opt/cimon/controller/
    # write version file
    git rev-parse HEAD > /opt/cimon/controller/version.txt
    echo "$(date) installed new version $(git rev-parse HEAD) to /opt/cimon/controller"
    sudo service cimon restart
    echo "$(date) restarted service"
fi
# else, nothing to do (current version allready installed)
