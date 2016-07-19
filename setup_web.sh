#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016

SETUPDIR=$(dirname $(readlink -f $0))/freesbb

echo "$(date) Starting setup web..."

$SETUPDIR/web/install_web.sh
RC=$?
if [[ $RC -ne 0 ]]; then
    echo "Error installing web $RC"
    exit $RC
fi
echo "$(date) Setup web terminated OK"
