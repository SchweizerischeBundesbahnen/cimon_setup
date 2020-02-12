#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# Setup the Rasberry and the scripts
#
CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "$(date) Setup terminated in ERROR"
        exit $RC
    fi
}

echo "$(date) Starting setup controller..."
SETUPDIR=$(dirname $(readlink -f $0))

echo "$(date) Creating the /opt/cimon dir if required..."
bash $SETUPDIR/create_cimon_dir.sh
CheckReturncode
echo "$(date) Cimon dir created"

# scripts aufrufen
# Clewarecontrol - Steuerung USB Ampel
echo "$(date) Installing clewarecontrol..."
bash $SETUPDIR/controller/install_clewarecontrol.sh
CheckReturncode
echo "$(date) Clewarecontrol installed"

echo "$(date) Installing sispmctl..."
# Sispmctl - Steuerung Energenie Steckdosenleiste
bash $SETUPDIR/controller/install_sispmctl.sh
CheckReturncode
echo "$(date) Sispmctl installed"

echo "$(date) Installing cimon controller..."
# Cimon Controller Scripts
bash $SETUPDIR/controller/install_controller.sh
CheckReturncode
echo "$(date) Cimon controller installed"

# Clewarecontrol - Steuerung USB Ampel
echo "$(date) Installing hue..."
bash $SETUPDIR/controller/install_hue.sh
CheckReturncode
echo "$(date) Hue installed"

echo "$(date) Setup controller terminated OK"
