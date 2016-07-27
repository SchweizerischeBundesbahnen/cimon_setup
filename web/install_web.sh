#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016

SETUPDIR=$(dirname $(readlink -f $0))

echo "Installing cimon web component"

# install apache ewebserver
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install apache2
 if [[ $? -ne 0 ]]; then
    echo "Failed to install apache2 webserver"
    exit 58
fi

# configure apache
sudo bash -c "echo -e '\n<Directory /opt/cimon/web/>\n        Options Indexes FollowSymLinks\n        AllowOverride None\n        Require all granted\n</Directory>' > /etc/apache2/apache2.conf"
sudo cp $SETUPDIR/sites-available/007-cimon.conf /etc/apache2/sites-available/007-cimon.conf
sudo ln -s  /etc/apache2/sites-available/007-cimon.conf /etc/apache2/sites-enabled/007-cimon.conf

sudo service apache2 restart

bash $SETUPDIR/update_web.sh

echo "Installed cimon web component"

