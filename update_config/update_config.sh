#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# update_config the remote configuration

mount /mnt/mydrive 2> /dev/null
if [[ ! -d "/mnt/mydrive/config" ]]; then
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

MYDIR=$(dirname $(readlink -f $0))

# now start the actual update process

UpdateIfChanged() {
    REMOTE=$1
    LOCAL=$2
    if [[ $(cmp --silent $REMOTE $LOCAL) != 0 ]]; then
       cp -f $REMOTE $LOCAL 2> /dev/null
       echo "$(date) updated $LOCAL"
       return 1
    fi
    return 0
}

# update_config and restart service only if remote files are newer and different

mkdir -p ~/cimon 2> /dev/null
mkdir -p ~/cimon/plugins 2> /dev/null

# first the config file
UpdateIfChanged /mnt/mydrive/config/$HN/cimon.yaml ~/cimon/cimon.yaml
RESTART=$?

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
   sudo service cimon restart 2> /dev/null
   echo $(date) > /mnt/mydrive/config/$HN/last_update 2> /dev/null
   echo "$(date) restarted service"
fi
umount /mnt/mydrive > /dev/null 2>&1