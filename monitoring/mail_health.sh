#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# mail the current state from the logs regularily

function TailLog(){
    local FILE=/var/log/cimon/$1
    if [[ -f  $FILE ]]; then
        echo $(tail -$2l $FILE)
    else
        echo "empty"
    fi
}

if ! [[ -f ~/cimon/.mailto ]]; then
    echo "No mailto address defined"
    exit 0
fi

TO=$(cat ~/cimon/.mailto)
HOST=$(hostname)
LOG=$(TailLog cimon.log 99)
STDOUTLOG=$(TailLog cimon_stdouterr.log 29)
CONFIGLOG=$(TailLog update_config.log 29)
AUTOUPDATELOG=$(TailLog autoupdate_cimon.log 29)
DISKFULLLOG=$(TailLog mail_disk_full.log 19)
MAILADRESSLOG=$(TailLog mail_address.log 19)

echo -e "Current health state of cimon $HOST at $(date)\n\n-----cimon.log-----\n$LOG\n\n-----cimon_stdouterr.log-----\n$STDOUTLOG\n\n-----update_config.log-----\n$CONFIGLOG\n\n-----autoupdate_cimon.log-----\n$AUTOUPDATELOG\n\n-----mail_disk_full.log-----\n$DISKFULLLOG\n\n-----mail_address.log-----\n$MAILADRESSLOG" | mail -s "CIMON $HOST: Health state info" $TO
