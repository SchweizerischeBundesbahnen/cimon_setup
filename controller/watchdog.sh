#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# check if cimon controller is running, and send mail and restart if not
SendMailWithLogs() {
    if [[ -f ~/cimon/.mailto ]]; then
        echo -e "$2\n-----cimon.log-----\n$(tail -99l /var/log/cimon/cimon.log)\n\n-----cimon_stdouterr.log-----\n$(tail -29l /var/log/cimon/cimon_stdouterr.log)" | mail -s "CIMON $(hostname): $1" $(cat ~/cimon/.mailto)
     fi
}

if [[ -f ~/cimon/.autostart_controller ]] && [[ "$(cat ~/cimon/.autostart_controller)" == "true" ]]; then
    sudo service cimon status 1>/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        SendMailWithLogs "Cimon controller not running"  "Cimon Controller on $(hostname) was not running at $(date), starting."
        sudo service cimon start >> /var/log/cimon/cimon_stdouterr.log 2>&1
        if [[ $? -ne 0 ]]; then
            echo "$(date) Start cimon controller failed." >> /var/log/cimon/cimon_stdouterr.log
            SendMailWithLogs  "Cimon controller start failed" "Cimon Controller on $(hostname) start failed at $(date)."
        else
            sleep 10 # make sure its started
            sudo service cimon status 1>/dev/null 2>&1
            if [[ $? -ne 0 ]]; then
                echo "$(date) Cimon controller did not start." >> /var/log/cimon/cimon_stdouterr.log
                SendMailWithLogs  "Cimon controller did not start" "Cimon Controller on $(hostname) did not start at $(date)."
            else
                echo "$(date) Cimon controller started." >> /var/log/cimon/cimon_stdouterr.log
            fi
        fi
    fi
fi