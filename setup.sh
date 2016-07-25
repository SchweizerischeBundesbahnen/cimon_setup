#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# Setup the Rasberry and the scripts
#
# Getestet für Rasberry Pi 2 und 3
# Vorraussetzung: Rassbian (Debian Jessy) bereits installiert, am besten SD-Karte vorinstalliert kaufen oder dd unter Linux bzw. Win32DiskImager verwenden
# und das Gerät ist an einem Netz (nicht SBB!) angehängt
#
# Dieses Cimon GIT Repository clonen und usb_stick/pack_usb_stick.bat <laufwerk> oder usb_stick/pack_usb_stick.sh <mountpoint> aufrufen
# Tastatur und Uhrzeit einstellen (Tastatureinstellung via "Menu->Preferences->Rasberry Pi Configuration" war nach Restart weg, ist ev. mittlerweile gefixed..., Alternative "sudo rasbi-config")
#
CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "$(date) Setup terminated in ERROR"
        exit $RC
    fi
}

echo "$(date) Starting setup..."
SETUPDIR=$(dirname $(readlink -f $0))
# make sure we are connected before continuing...
wget -q -O- http://www.search.ch >> /dev/null
CheckReturncode

echo "$(date) Upgrading and installing packages..."
# prepare Rasberry
# update package list and upgrade distribution, remove unused
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
CheckReturncode
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
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

echo "$(date) Installing chromium..."
# Chromium Browser
bash $SETUPDIR/chromium/install_chromium.sh
CheckReturncode
echo "$(date) Sispmctl installed"

echo "$(date) Creating the /opt/cimon dir if required..."
bash $SETUPDIR/create_cimon_dir.sh
CheckReturncode
echo "$(date) Cimon dir created"

# scripts aufrufen
# Clewarecontrol - Steuerung USB Ampel
echo "$(date) Installing clewarecontrol..."
bash $SETUPDIR/controller/install_clewarecontrol.sh
CheckReturncode
echo "$(date) Clewarecontrol installed"

echo "$(date) Installing sispmctl..."
# Sispmctl - Steuerung Energenie Steckdosenleiste
bash $SETUPDIR/controller/install_sispmctl.sh
CheckReturncode
echo "$(date) Sispmctl installed"

echo "$(date) Installing cimon controller..."
# Cimon Controller Scripts
bash $SETUPDIR/controller/install_controller.sh
CheckReturncode
echo "$(date) Cimon controller installed"

echo "$(date) Installing autoupdate..."
# Cimon Controller Scripts
bash $SETUPDIR/autoupdate/install_autoupdate.sh
CheckReturncode
echo "$(date) Autoupdate installed"

echo "$(date) Setup terminated OK"
