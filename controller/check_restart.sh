#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# check if cimon controller is running, and send mail and restart if not
sudo service cimon status
if {{ $? -ne 0  ]]; then
    if [[ -f ~/cimon/.mailto  ]]; then
        echo -e "Cimon Controller on $(hostname) was not running, starting. It may run now.\n-----cimon.log-----\n$(tail -99l /var/log/cimon/cimon.log)\n\n-----cimon_stdouterr.log-----\n$(tail -29l /var/log/cimon/cimon_stdouterr.log)" | mail -s "CIMON $(hostname): Cimon controller not running" $(grep ~/cimon/.mailto)
    fi
    sudo service cimon start
fi