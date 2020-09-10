#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016

SETUPDIR=$(dirname $(readlink -f $0))

echo "$(date) Starting setup web..."

bash $SETUPDIR/create_cimon_dir.sh

mkdir -p $SETUPDIR/web

# install http server & angular client
bash $SETUPDIR/web/install_web.sh
RC=$?
if [[ $RC -ne 0 ]]; then
    echo "Error installing web $RC"
    exit $RC
fi

# setup browser auto-start
bash $SETUPDIR/web/install_start_web_browser.sh
RC=$?
if [[ $RC -ne 0 ]]; then
    echo "Error installing web browser start script $RC"
    exit $RC
fi

echo "$(date) Setup web terminated OK"
