#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# copy the remote configuration to ~/cimon and restart if nescessary

if [[ ! $1 ]]; then
    echo "1 parameter required: remote dir"
    exit 32
fi

REMOTE_DIR=$1
RESTART=0

UpdateIfChanged() {
    REMOTE=$1
    LOCAL=$2
    MANDATORY=$3
    if [[ ! -f $REMOTE ]]; then
        if [[ $MANDATORY -eq 1 ]]; then
            echo "$(date) $REMOTE not found"
        fi
        return 0
    fi
    cmp --silent $REMOTE $LOCAL 2>&1 1>/dev/null
    if [[ $? -ne 0 ]]; then
       echo "$(date) Change detected, copying $REMOTE to $LOCAL"
       cp -f $REMOTE $LOCAL 1>/dev/null 2>&1
       if [[ $? -ne 0 ]]; then
            echo "$(date) Copy of $REMOTE to $LOCAL failed"
            exit 11
       fi
       return 1
    fi
    return 0
}

# update_config and restart service only if remote files are newer and different

# update the python plugin scripts
shopt -s nullglob # make sure the for loop works, else if nothing is found the search string is returned as such
for REMOTE_PLUGIN in $REMOTE_DIR/plugins/*.py; do
    if [[ ! -d ~/cimon/plugins ]]; then
        mkdir -p ~/cimon/plugins
    fi
    UpdateIfChanged $REMOTE_PLUGIN ~/cimon/plugins/$(basename $REMOTE_PLUGIN) 1
    if [[ $? -eq 1 ]]; then
        RESTART=1
    fi
done
shopt -u nullglob

# then the config file - check first, copy only if it is OK
/usr/bin/python3 /opt/cimon/controller/cimon.py --validate --config $REMOTE_DIR/cimon.yaml > /dev/null
if [[ $? -ne 0 ]]; then
    echo "$(date) Invalid configuration $REMOTE_DIR/cimon.yaml or failed to validate configuration"
    exit 33
fi
UpdateIfChanged $REMOTE_DIR/cimon.yaml ~/cimon/cimon.yaml 1
RESTART=$?


# update the script configuration files if changed
UpdateIfChanged $REMOTE_DIR/.autostart_controller ~/cimon/.autostart_controller 0
UpdateIfChanged $REMOTE_DIR/.autostart_web ~/cimon/.autostart_web 0
UpdateIfChanged $REMOTE_DIR/.mailto ~/cimon/.mailto 0
UpdateIfChanged $REMOTE_DIR/.git_branch ~/cimon/.git_branch 0

# if something was changed restart
if [[ $RESTART -eq 1 ]] && [[ -f ~/cimon/.autostart_controller ]] && [[ "$(cat ~/cimon/.autostart_controller)" == "true" ]]; then
   sudo service cimon restart  1>/dev/null 2>&1
   echo "$(date) restarted service"
fi

exit $RESTART