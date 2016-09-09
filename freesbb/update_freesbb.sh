#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# Update the freesbb script

SETUPDIR=$(dirname $(readlink -f $0))

pushd .

mkdir -p /opt/cimon/freesbb > /dev/null 2>&1

git rev-parse 2> /dev/null
if [[ $? -eq 0 ]]; then
    GIT_VERSION=$(git rev-parse HEAD)
else
    GIT_VERSION="unknown_$(date +%s)"
fi

if [[ ! -f /opt/cimon/freesbb/.version ]] || [[ $(cat /opt/cimon/freesbb/.version) != $GIT_VERSION ]]; then
    echo "$(date) Installing new version of the freesbb script and chronjob..."

    # script to click the accept (gratis ins internet) button
    cp -rf $SETUPDIR/src/*.py /opt/cimon/freesbb/
    sudo cp -f $SETUPDIR/cron.d/freesbb /etc/cron.d/freesbb
    sudo chmod g-x,o-x /etc/cron.d/freesbb

    echo $GIT_VERSION > /opt/cimon/freesbb/.version
    echo "$(date) Freesbb script and chronjob installed"
fi

popd