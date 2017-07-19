#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016

SETUPDIR=$(dirname $(readlink -f $0))

pushd .

LATEST_VERSION=$(curl --fail --silent https://github.com/SchweizerischeBundesbahnen/cimon_web/releases/latest | sed -n 's@^.*/SchweizerischeBundesbahnen/web_browser/releases/tag/\([^"]*\)">redirected.*$@\1@p')

mkdir -p /opt/cimon/web

if [[ ! -f /opt/cimon/web/.version ]] || [[ $(cat /opt/cimon/web/.version) != $LATEST_VERSION ]]; then
    if [ -d /tmp/cimon_web ]; then
        rm -rf /tmp/cimon_web
    fi
    mkdir -p /tmp/cimon_web
    cd

    wget --content-disposition --no-check-certificate --directory-prefix=/tmp/cimon_web https://github.com/SchweizerischeBundesbahnen/cimon_web/releases/download/$LATEST_VERSION/release.zip
g
    if [ ! -f /tmp/cimon_web/release.zip ]; then
        echo "File release.zip not downloaded from github for web_browser $LATEST_VERSION"
        exit 78
    fi
    unzip -d /tmp/cimon_web/release /tmp/cimon_web/release.zip

    mkdir -p /opt/cimon/web/html
    rm -rf /opt/cimon/web/html/*
    cp -rf /tmp/cimon_web/release/* /opt/cimon/web/html/
    echo "$(date) installed new version $(git rev-parse HEAD) to /opt/cimon/web"
    sudo service apache2 restart
    echo "$(date) restarted apache2"
    echo $LATEST_VERSION > /opt/cimon/web/.version
fi

popd
