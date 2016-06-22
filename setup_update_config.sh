#!/usr/bin/env bash
# configure the update_config mechanism via mydrive

setupdir=$(dirname $(readlink -f $0))

# install the mydrive
bash $setupdir/update_config/install_mydrive.sh $1 $2
if [[ $? -ne 0 ]]; then
    echo "$(date) Install mydrive terminated in ERROR"
    exit $?
fi
bash $setupdir/update_config/install_update_config.sh $3