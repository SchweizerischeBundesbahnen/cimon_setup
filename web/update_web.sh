#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016

pushd .

bash $SETUPDIR/../autoupdate/clone_or_pull_github.sh /tmp/cimon_github cimon_web

cd /tmp/cimon_Fgithub/cimon_web

mkdir -p /opt/cimon/web

if [[ ! -f /opt/cimon/web/.version ]] || [[ $(cat /opt/cimon/web/.version) != $(git rev-parse HEAD) ]]; then
    mkdir -p /opt/cimon/web/html
    rm -rf /opt/cimon/web/html/*
    cp -rf src/page/* /opt/cimon/web/html/
    echo "$(date) installed new version $(git rev-parse HEAD) to /opt/cimon/web"
    sudo service apache2 restart
    echo "$(date) restarted apache2"
    git rev-parse HEAD > /opt/cimon/web/.version
fi

popd
