#!/usr/bin/env bash
# Setup the Rasberry and the scripts
#
# Getestet für Rasberry Pi 2 und 3, allerdings nicht in einem und mit Try-and-Error.
# Vorraussetzung: Rassbian (Debian Jessy) bereits installiert, am besten SD-Karte vorinstalliert kaufen oder dd unter Linux bzw. Win32DiskImager verwenden
# und das Gerät ist an einem Netz (nicht SBB!) angehängt
#
# Cimon GIT Repository clonen (ssh://git@code.sbb.ch:7999/kd_bm/cimon.git, https://u206123@code.sbb.ch/scm/kd_bm/cimon.git) auf einen USB Stick kopieren
# Tastatur und Uhrzeit einstellen (Tastatureinstellung via "Menu->Preferences->Rasberry Pi Configuration" war nach Restart weg, ist ev. mittlerweile gefixed..., Alternative "sudo rasbi-config")
#
CheckReturncode() {
    if [[ $? -ne 0 ]]; then
        echo "$(date) Setup terminated in ERROR"
        exit $?
    fi
}

echo "$(date) Starting setup..."
setupdir=$(dirname $(readlink -f $0))
# make sure we are connected before continuing...
wget -q -O- http://www.search.ch >> /dev/null
CheckReturncode

echo "$(date) Upgrading and installing packages..."
# Rasberry vorbereiten
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
CheckReturncode
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
CheckReturncode
sudo DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python3.4-dev
CheckReturncode
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install dos2unix
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install raspi-config
echo "$(date) Packages upgraded and installed"

echo "$(date) Setting timezone..."
# set timezone
sudo sh -c 'echo "Europe/Zurich" > /etc/timezone'
sudo dpkg-reconfigure -f noninteractive tzdata
echo "$(date) Timezone set to Europe/Zurich"

echo "$(date) Installing chromium..."
# Chromium Browser
bash $setupdir/chromium/install_chromium.sh
CheckReturncode
echo "$(date) Sispmctl installed"

# scripts aufrufen
# Clewarecontrol - Steuerung USB Ampel
echo "$(date) Installing clewarecontrol..."
bash $setupdir/controller/install_clewarecontrol.sh
CheckReturncode
echo "$(date) Clewarecontrol installed"

echo "$(date) Installing sispmctl..."
# Sispmctl - Steuerung Energenie Steckdosenleiste
bash $setupdir/controller/install_sispmctl.sh
CheckReturncode
echo "$(date) Sispmctl installed"

echo "$(date) Installing cimon controller..."
# Cimon Controller Scripts
bash $setupdir/controller/install_controller.sh
CheckReturncode
echo "$(date) Cimon controller installed"

echo "$(date) Installing autoupdate..."
# Cimon Controller Scripts
bash $setupdir/autoupdate/install_autoupdate.sh
CheckReturncode
echo "$(date) Autoupdate installed"

echo "$(date) Setup terminated OK"
