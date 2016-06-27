#!/usr/bin/env bash
# cimon, SBB, FSe 2016
# update_config the remote configuration

mount /mnt/mydrive 2> /dev/null
if [[ ! -d "/mnt/mydrive/config" ]]; then
    echo "Could not mount mydrive or config dir on mydrive not found"
    exit 42
fi
mydir=$(dirname $(readlink -f $0))

UpdateIfChanged() {
    REMOTE=$1
    LOCAL=$2
    if [[ $REMOTE -nt $LOCAL && $(cmp --silent $REMOTE $LOCAL) != 0 ]]; then
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
UpdateIfChanged /mnt/mydrive/config/$(hostname)/cimon.yaml ~/cimon/cimon.yaml
RESTART=$?

# then the python plugin scripts
for REMOTE_PLUGIN in /mnt/mydrive/config/$(hostname)/plugins/*.py; do
    UpdateIfChanged $REMOTE_PLUGIN ~/cimon/plugins/$(basename $REMOTE_PLUGIN)
    if [[ $? -eq 1 ]]; then
        RESTART=1
    fi
done

# write the ip and mac address onto the mydrive
bash $mydir/dump_addresses.sh /mnt/mydrive/config/$(hostname) > /dev/null 2>&1

# if something was changed restart
if [[ $RESTART -eq 1 ]]; then
   sudo service cimon restart 2> /dev/null
   touch /mnt/mydrive/config/$(hostname)/last_update 2> /dev/null
   echo "$(date) restarted service"
fi
umount /mnt/mydrive > /dev/null 2>&1