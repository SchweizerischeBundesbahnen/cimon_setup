#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016

SETUPDIR=$(dirname $(readlink -f $0))

echo "Installing Cimon web component"

# install lighttpd webserver
if ! sudo DEBIAN_FRONTEND=noninteractive apt-get -y install lighttpd
then
    echo "Failed to install lighttpd webserver"
    exit 58
fi

# copy lighttpd configfile
sudo cp $SETUPDIR/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf

sudo service lighttpd restart

# install angular client
bash $SETUPDIR/update_web_client.sh

# copy update script to keep the client up to date automatically
sudo cp $SETUPDIR/update_web_client.sh /opt/cimon/web/update_web_client.sh
sudo chmod a+rx /opt/cimon/web/*.sh

# disable screensaver/powersave
bash $SETUPDIR/install_disable_screensleep.sh

echo "Installed Cimon web component"

