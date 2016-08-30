#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# mail the current state from the logs regularily

echo -e "Current health state of cimon $(hostname) at $(date)\n\n-----cimon.log-----\n$(tail -99l /var/log/cimon/cimon.log)\n\n-----cimon_stdouterr.log-----\n$(tail -29l /var/log/cimon/cimon_stdouterr.log)\n\n-----update_config.log-----\n$(tail -29l /var/log/cimon/update_config.log)\n\n-----autoupdate_cimon.log-----\n$(tail -29l /var/log/cimon/autoupdate_cimon.log)\n\n-----mail_disk_full.log-----\n$(tail -19l /var/log/cimon/mail_disk_full.log)\n\n-----mail_address.log-----\n$(tail -19l /var/log/cimon/mail_address.log)" | mail -s "CIMON $(hostname): Health state info" $(cat ~/cimon/.mailto)
