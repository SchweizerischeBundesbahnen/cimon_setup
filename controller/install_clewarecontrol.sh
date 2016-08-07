#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
## Clewarecontrol installieren
# https://www.vanheusden.com/clewarecontrol/
SETUPDIR=$(dirname $(readlink -f $0))
pushd .
which clewarecontrol  1>/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    # Vorraussetzung: libhidapi-dev
    sudo apt-get -y install libhidapi-dev
    ### Clewarecontrol
    rm -rf /tmp/cimon_clewarecontrol 1>/dev/null 2>&1
    mkdir /tmp/cimon_clewarecontrol 1>/dev/null 2>&1
    cd /tmp/cimon_clewarecontrol
    # Clewarecontrol herunterladen: https://www.vanheusden.com/clewarecontrol/#download
    if [[ ! -d clewarecontrol ]]; then
        rm -rf clewarecontrol
    fi
    git clone https://github.com/flok99/clewarecontrol.git
    cd clewarecontrol
    git reset --hard e12ab10fdc720f0186cd1661f38573c25e743373
    make clewarecontrol > /dev/null
    sudo make install > /dev/null
    ### USB Device als Nicht-Root
    sudo cp $SETUPDIR/rules.d/90-cleware-ampel.rules /etc/udev/rules.d/90-cleware-ampel.rules
fi
# done
popd
which clewarecontrol
