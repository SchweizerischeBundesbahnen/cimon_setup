#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# Create the cimon directory

if [[ ! -d /opt/cimon ]]; then
    sudo mkdir -p /opt/cimon  1>/dev/null 2>&1
    sudo chown pi /opt/cimon  1>/dev/null 2>&1
    sudo chgrp pi /opt/cimon  1>/dev/null 2>&1
    sudo chmod a+rx /opt/cimon 1>/dev/null 2>&1
fi

if [[ ! -d /opt/cimon ]]; then
    exit 1 # creation failed...
fi
exit 0