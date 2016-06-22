#!/usr/bin/env bash
## Clewarecontrol installieren
# https://www.vanheusden.com/clewarecontrol/
setupdir=$(dirname $(readlink -f $0))
pushd .
# Vorraussetzung: libhidapi-dev
sudo apt-get -y install libhidapi-dev
### Clewarecontrol
rm -rf /tmp/cimon_clewarecontrol 2> /dev/null
mkdir /tmp/cimon_clewarecontrol 2> /dev/null
cd /tmp/cimon_clewarecontrol
# Clewarecontrol herunterladen: https://www.vanheusden.com/clewarecontrol/#download
wget --content-disposition 'https://www.vanheusden.com/clewarecontrol/files/clewarecontrol-4.1.tgz'
# make clewarecontrol
tar -xvf clewarecontrol-4.1.tgz
cd clewarecontrol-4.1
sed -i -- 's/hidapi/hidapi-libusb/g' Makefile
make clewarecontrol
sudo make install
### USB Device als Nicht-Root
sudo cp $setupdir/rules.d/90-cleware-ampel.rules /etc/udev/rules.d/90-cleware-ampel.rules
# done
popd
which clewarecontrol
