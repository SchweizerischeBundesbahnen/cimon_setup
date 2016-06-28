#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# Energenie Steckdose setup
# siehe http://sispmctl.sourceforge.net/
# https://www.sweetpi.de/blog/224/usb-steckdosenleisten-mit-dem-raspberry-pi-schalten
SETUPDIR=$(dirname $(readlink -f $0))
pushd .
# Vorraussetzung: libusb-dev
sudo apt-get install libusb-dev
# download sispmclt
rm -rf /tmp/cimon_sispmctl 2> /dev/null
mkdir /tmp/cimon_sispmctl 2> /dev/null
cd /tmp/cimon_sispmctl
wget --content-disposition 'https://sourceforge.net/projects/sispmctl/files/latest/download?source=typ_redirect'
# make sispmclt
tar xzvf sispmctl-*.tar.gz
cd sispmctl-*
./configure
make
sudo make install
# refresh the libraries
sudo ldconfig
# USB Device als User
sudo cp $SETUPDIR/rules.d/91-energenie-steckdose.rules /etc/udev/rules.d/
# done
popd
which sispmctl
