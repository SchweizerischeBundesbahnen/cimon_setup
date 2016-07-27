#!/usr/bin/env bash
# Setup the Rasberry and the scripts
#

CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "$(date) Setup terminated in ERROR"
        exit $RC
    fi
}

echo "$(date) Starting setup autoupdate..."
SETUPDIR=$(dirname $(readlink -f $0))

echo "$(date) Creating the /opt/cimon dir if required..."
bash $SETUPDIR/create_cimon_dir.sh
CheckReturncode
echo "$(date) Cimon dir created"

echo "$(date) Installing autoupdate..."
# Cimon Controller Scripts
bash $SETUPDIR/autoupdate/install_autoupdate.sh
CheckReturncode
echo "$(date) Autoupdate installed"

echo "$(date) Setup autoupdate terminated OK"
