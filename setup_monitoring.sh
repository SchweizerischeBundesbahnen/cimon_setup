#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# configure the monitoring mechanism

CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "$(date) Setup monitoring terminated in ERROR"
        exit $RC
    fi
}

SETUPDIR=$(dirname $(readlink -f $0))

echo "$(date) Creating the /opt/cimon dir if required..."
bash $SETUPDIR/create_cimon_dir.sh
CheckReturncode

echo "$(date) Creating the ~/cimon dir if required..."
mkdir -p ~/cimon 1>/dev/null 2>&1

echo "$(date) Starting setup monitoring..."

echo "$(date) Install monitoring..."
bash $SETUPDIR/monitoring/update_monitoring.sh
CheckReturncode
echo "$(date) Monitoring installed"

echo "$(date) Setup monitoring terminated OK"
