#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# mail the current address data

MYDIR=$(dirname $(readlink -f $0))

mkdir -p ~/cimon/status
bash $MYDIR/dump_addresses.sh ~/cimon/status > /dev/null 2>&1
NEWADDRESS=$?
if [[ $NEWADDRESS -eq 1 && -f ~/cimon/.mailto ]]; then
    echo -e "$(cat ~/cimon/status/address.txt)" | mail -s "CIMON $(hostname): New Address" $(cat ~/cimon/.mailto)
    if [[ $? -eq 0 ]]; then
        echo "$(date) New address detected, sent mail"
    else
        echo "$(date) Failed to send email, deleting stored address to enforce resending"
        rm -f ~/cimon/status/address.txt
    fi
fi
