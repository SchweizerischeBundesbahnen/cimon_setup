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
$MYDIR/copy_restart_if_changed.sh /mnt/mydrive/config/$HN
RESTARTED=$?
if [[ $RESTARTED -eq 1 ]]; then
   echo $(date) > /mnt/mydrive/config/$HN/last_update
fi

# write the ip and mac address onto the mydrive
bash $MYDIR/dump_addresses.sh /mnt/mydrive/config/$HN > /dev/null 2>&1

# end - unmount
umount /mnt/mydrive > /dev/null 2>&1