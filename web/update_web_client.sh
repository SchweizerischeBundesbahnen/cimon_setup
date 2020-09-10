#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016

SETUPDIR=$(dirname $(readlink -f $0))

pushd .

LATEST_VERSION=$(curl --fail --silent https://github.com/SchweizerischeBundesbahnen/cimon_web2/releases/latest | sed -n 's@^.*/SchweizerischeBundesbahnen/cimon_web2/releases/tag/\([^"]*\)">redirected.*$@\1@p')
echo "Latest version of cimon_web2 is $LATEST_VERSION"

mkdir -p /opt/cimon/web/html

if [[ ! -f /opt/cimon/web/.version ]] || [[ $(cat /opt/cimon/web/.version) != $LATEST_VERSION ]]; then
    if [ -d /tmp/cimon_web2 ]; then
        rm -rf /tmp/cimon_web2
    fi
    mkdir -p /tmp/cimon_web2
    cd

    wget --content-disposition --no-check-certificate --directory-prefix=/tmp/cimon_web2 https://github.com/SchweizerischeBundesbahnen/cimon_web2/releases/download/$LATEST_VERSION/cimon-web.zip

    if [ ! -f /tmp/cimon_web2/cimon-web.zip ]; then
        echo "File cimon-web.zip not downloaded from github for cimon_web2 $LATEST_VERSION"
        exit 78
    fi
    unzip -d /tmp/cimon_web2/release /tmp/cimon_web2/cimon-web.zip

    mkdir -p /opt/cimon/web/html
    rm -rf /opt/cimon/web/html/*
    cp -rf /tmp/cimon_web2/release/* /opt/cimon/web/html/
    echo "$(date) installed new version $LATEST_VERSION to /opt/cimon/web/html"
    echo $LATEST_VERSION > /opt/cimon/web/.version
fi

popd
