#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# update_config the remote configuration

# delete the cache as it may be stale, but make sure it is not mounted yet
mountpoint /mnt/mydrive 1>/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    rm -r /home/pi/.davfs2/cache/* > /dev/null 2>&1
fi
mount /mnt/mydrive  1>/dev/null 2>&1

mountpoint /mnt/mydrive 1>/dev/null 2>&1
if [[ $? -ne 0 || ! -d "/mnt/mydrive/config" ]]; then
    echo "Could not mount mydrive or config dir on mydrive not found"
    exit 42
fi

# create folder on mydrive and copy template file if no configuration exists yet
HN=$(hostname)

if [[ ! -d /mnt/mydrive/config/$HN ]]; then
    mkdir -p /mnt/mydrive/config/$HN
fi

if [[ ! -f /mnt/mydrive/config/$HN/cimon.yaml && -f /mnt/mydrive/config/templates/cimon.yaml ]]; then
    cp -n /mnt/mydrive/config/templates/cimon.yaml /mnt/mydrive/config/$HN/cimon.yaml
fi

if [[ ! -d ~/cimon || ! -d ~/cimon/plugins ]]; then
    mkdir -p ~/cimon 1>/dev/null 2>&1
    mkdir -p ~/cimon/plugins 1>/dev/null 2>&1
fi

MYDIR=$(dirname $(readlink -f $0))

# now start the actual update process
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
# first the config file
UpdateIfChanged /mnt/mydrive/config/$HN/cimon.yaml ~/cimon/cimon.yaml
RESTART=$?

# make sure the for loop works, else if nothing is found the search string is returned as such
shopt -s nullglob
# then the python plugin scripts
for REMOTE_PLUGIN in /mnt/mydrive/config/$HN/plugins/*.py; do
    UpdateIfChanged $REMOTE_PLUGIN ~/cimon/plugins/$(basename $REMOTE_PLUGIN)
    if [[ $? -eq 1 ]]; then
        RESTART=1
    fi
done

# write the ip and mac address onto the mydrive
bash $MYDIR/dump_addresses.sh /mnt/mydrive/config/$HN > /dev/null 2>&1

# if something was changed restart
if [[ $RESTART -eq 1 ]]; then
   sudo service cimon restart  1>/dev/null 2>&1
   echo $(date) > /mnt/mydrive/config/$HN/last_update  1>/dev/null 2>&1
   echo "$(date) restarted service"
fi
# end - unmount
umount /mnt/mydrive > /dev/null 2>&1