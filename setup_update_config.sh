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

if [[ ! $1  ]]; then
    echo "1 paramter required: <github_url_with_user_or_token>"
    exit 98
fi
URL=$1

SETUPDIR=$(dirname $(readlink -f $0))

mkdir -p ~/cimon 1>/dev/null 2>&1

echo "$(date) Starting setup update config..."
echo "$URL" > ~/cimon/.update_config_url

echo "$(date) Install update config..."
bash $SETUPDIR/update_config/update_update_config.sh
CheckReturncode
echo "$(date) Update config installed"

echo "$(date) Setup update config terminated OK"
