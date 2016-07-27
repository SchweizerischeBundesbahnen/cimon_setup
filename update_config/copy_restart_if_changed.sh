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
    if [[ ! -f $REMOTE ]]; then
        echo "$(date) $REMOTE not found"
        return 0
    fi
    cmp --silent $REMOTE $LOCAL 2>&1 1>/dev/null
    if [[ $? -ne 0 ]]; then
       echo "$(date) Copying $REMOTE to $LOCAL"
       cp -f $REMOTE $LOCAL 1>/dev/null 2>&1
       if [[ $? -ne 0 ]]; then
            echo "$(date) copy of $REMOTE to $LOCAL failed"
            exit 11
       fi
       return 1
    fi
    return 0
}

# update_config and restart service only if remote files are newer and different
# first the config file - check first, copy only if it is OK
/usr/bin/python3 /opt/cimon/controller/cimon.py --validate --config $REMOTE_DIR/cimon.yaml
if [[ $? -ne 0 ]]; then
    echo "$(date) Invalid configuration $REMOTE_DIR/cimon.yaml or failed to validate configuration"
    exit 33
fi
UpdateIfChanged $REMOTE_DIR/cimon.yaml ~/cimon/cimon.yaml
RESTART=$?

# make sure the for loop works, else if nothing is found the search string is returned as such
shopt -s nullglob
# then the python plugin scripts
for REMOTE_PLUGIN in $REMOTE_DIR/plugins/*.py; do
    UpdateIfChanged $REMOTE_PLUGIN ~/cimon/plugins/$(basename $REMOTE_PLUGIN)
    if [[ $? -eq 1 ]]; then
        RESTART=1
    fi
done

# if something was changed restart
if [[ $RESTART -eq 1 ]]; then
   sudo service cimon restart  1>/dev/null 2>&1
   echo "$(date) restarted service"
fi

exit $RESTART