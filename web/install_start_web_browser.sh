#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# configure  auto start of browser

SETUPDIR=$(dirname $(readlink -f $0))

pushd .

cd $SETUPDIR

sudo mkdir -p /opt/cimon/web

# copy startup script
sudo cp -f $SETUPDIR/start_web_browser.sh /opt/cimon/web/start_web_browser.sh
sudo chmod a+rx /opt/cimon/web/*.sh

# install cron job
sudo cp -f $SETUPDIR/cron.d/web_browser /etc/cron.d/web_browser
sudo chmod g-x,o-x /etc/cron.d/web_browser

popd
