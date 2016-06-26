#!/usr/bin/env bash
# update_config cimon, do not update_config configuration

setupdir=$(dirname $(readlink -f $0))

CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "Update terminated in ERROR"
        exit $RC
    fi
}
echo "$(date) Update if required..."

# upgrade packages
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
CheckReturncode
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade
CheckReturncode

# update_config the controllerscripts
bash $setupdir/controller/update_controller.sh
CheckReturncode

echo "$(date) Update terminated OK"
