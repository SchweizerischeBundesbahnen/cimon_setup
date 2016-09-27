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
if [[ ! -f /opt/cimon/web_browser/.version ]] || [[ $(cat /opt/cimon/web_browser/.version) != $(git rev-parse HEAD) ]]; then
    mkdir -p /opt/cimon/web_browser

    cp -f $SETUPDIR/start_web_browser.sh /opt/cimon/web_browser/start_web_browser.sh
    chmod a+rx /opt/cimon/web_browser/*.sh

    sudo cp -f $SETUPDIR/cron.d/web_browser /etc/cron.d/web_browser
    sudo chmod g-x,o-x /etc/cron.d/web_browser
    git rev-parse HEAD > /opt/cimon/web_browser/.version
fi

popd