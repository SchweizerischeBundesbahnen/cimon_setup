#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# configure the update_config mechanism via mydrive

CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "$(date) Setup update config terminated in ERROR"
        exit $RC
    fi
}

setupdir=$(dirname $(readlink -f $0))

echo "$(date) Starting setup update config..."
echo "$(date) Install mydrive..."
# install the mydrive
bash $setupdir/update_config/install_mydrive.sh $1 $2
CheckReturncode
echo "$(date) Mydrive installed"

echo "$(date) Install update config..."
bash $setupdir/update_config/install_update_config.sh $3
CheckReturncode
echo "$(date) Update config installed"

echo "$(date) Setup update config terminated OK"
