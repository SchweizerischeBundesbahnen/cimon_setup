#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
## Clewarecontrol installieren
# https://www.vanheusden.com/clewarecontrol/
SETUPDIR=$(dirname $(readlink -f $0))
pushd .
# Vorraussetzung: libhidapi-dev
sudo apt-get -y install libhidapi-dev
### Clewarecontrol
rm -rf /tmp/cimon_clewarecontrol 1>/dev/null 2>&1
mkdir /tmp/cimon_clewarecontrol 1>/dev/null 2>&1
cd /tmp/cimon_clewarecontrol
# Clewarecontrol herunterladen: https://www.vanheusden.com/clewarecontrol/#download
wget --content-disposition 'https://www.vanheusden.com/clewarecontrol/files/clewarecontrol-4.3.tgz'
# make clewarecontrol
tar -xvf clewarecontrol-4.3.tgz
cd clewarecontrol-4.3
sed -i -- 's/hidapi/hidapi-libusb/g' Makefile
make clewarecontrol
sudo make install
### USB Device als Nicht-Root
sudo cp $SETUPDIR/rules.d/90-cleware-ampel.rules /etc/udev/rules.d/90-cleware-ampel.rules
# done
popd
which clewarecontrol
