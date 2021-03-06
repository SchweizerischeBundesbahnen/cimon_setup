#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# this is the only script that can not be distributed using the update_config mechanism...
# it would be like muenchhausen
SCRIPTDIR=$(dirname $(readlink -f $0))

# checkout the setup repo
bash $SCRIPTDIR/clone_or_pull_github.sh /tmp/cimon_github cimon_setup
RC=$?
if [[ $RC -eq 0 ]]; then
    # if checkout was OK, call the update script
    bash /tmp/cimon_github/cimon_setup/update.sh
    RC=$?
fi
# send an email in case the autoupdate failed (if email is configured)
if [[ $RC -eq 0 ]]; then
    echo "Autoupdated $(hostname) sucessfully at $(date)" | bash $SCRIPTDIR/../monitoring/send_mail.sh "CIMON $(hostname): Autoupdate OK"
else
    echo -e "Autoupdate $(hostname) failed at at $(date)\n\n $(tail -99l /var/log/cimon/autoupdate_cimon.log)" | bash $SCRIPTDIR/../monitoring/send_mail.sh "CIMON $(hostname): Autoupdate failed"
fi
