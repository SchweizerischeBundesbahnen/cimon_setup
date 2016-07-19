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

if [[ "$1" != "github" && "$1" != "mydrive" ]]; then
    echo "first parameter has to be 'git' or 'mydrive'"
    exit 97
fi
MODE=$1
if [[ "$MODE" == "github" && ! $2  ]]; then
    echo "3 paramters required: github <github_url_with_user_or_token>"
    exit 98
fi
if [[ "$MODE" == "mydrive" && ( ! $2  || ! $3 ) ]]; then
    echo "3 paramters required: mydrive <mydrive_user> <mydrive password>"
    exit 99
fi

SETUPDIR=$(dirname $(readlink -f $0))

mkdir -p ~/cimon 1>/dev/null 2>&1
echo "$MODE" > ~/cimon/.update_config_mode

echo "$(date) Starting setup update config..."
if [[ "$MODE" == "mydrive" ]]; then
    echo "$(date) Install mydrive..."
    # install the mydrive
    bash $SETUPDIR/update_config/mydrive/install_mydrive.sh $1 $2
    CheckReturncode
    echo "$(date) Mydrive installed"
else
    echo "$2" > ~/cimon/.update_config_url
fi

echo "$(date) Install update config..."
bash $SETUPDIR/update_config/install_or_update_update_config.sh
CheckReturncode
echo "$(date) Update config installed"

echo "$(date) Setup update config terminated OK"
