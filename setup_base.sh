#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# Setup the base packages
#
CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "$(date) Setup terminated in ERROR"
        exit $RC
    fi
}

echo "$(date) Starting setup base..."
SETUPDIR=$(dirname $(readlink -f $0))
# make sure we are connected before continuing...
wget -q -O- http://www.search.ch >> /dev/null
CheckReturncode

echo "$(date) Upgrading and installing packages..."
# prepare Rasberry
# update package list and upgrade distribution, remove unused
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
CheckReturncode
sudo DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
CheckReturncode
sudo DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
# make sure python 3.4 is available
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python3.4
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python3.4-dev
CheckReturncode
# may be usefull for files directly copied from windows
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install dos2unix
CheckReturncode
# Raspi config for permaanent change of keyboard layout
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install raspi-config
CheckReturncode
echo "$(date) Packages upgraded and installed"

echo "$(date) Setting timezone..."
# set timezone
sudo sh -c 'echo "Europe/Zurich" > /etc/timezone'
sudo dpkg-reconfigure -f noninteractive tzdata
CheckReturncode
echo "$(date) Timezone set to Europe/Zurich"

echo "$(date) Setup base terminated OK"
