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

# configure lighttpd
if grep -Fq "/var/www/html" /etc/lighttpd/lighttpd.conf
then
    sudo sed -i -e 's/\/var\/www\/html/\/opt\/cimon\/web\/html/g' /etc/lighttpd/lighttpd.conf
fi

# configure apache
sudo bash -c "echo -e '\n<Directory /opt/cimon/web/>\n        Options Indexes FollowSymLinks\n        AllowOverride None\n        Require all granted\n</Directory>' > /etc/apache2/apache2.conf"
sudo cp $SETUPDIR/sites-available/007-cimon.conf /etc/apache2/sites-available/007-cimon.conf
sudo ln -s  /etc/apache2/sites-available/007-cimon.conf /etc/apache2/sites-enabled/007-cimon.conf

sudo service lighttpd restart

# disable web installation as it is broken for now
#bash $SETUPDIR/update_web.sh

echo "Installed Cimon web component"

