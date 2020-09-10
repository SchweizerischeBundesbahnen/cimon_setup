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
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# Setup everything from an usb stick packed by pack_usb_stick

CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "$(date) Setup terminated in ERROR"
        popd
        exit $RC
    fi
}

pushd .

SETUPDIR=$(dirname $(readlink -f $0))

USAGE="Usage: -n <hostname> [-p <password>]  [-k <keyfile>] [-s <ssmtp.conf file>] [-e <email sender>] [-t <send monitoring email to address>] [-g <config github_url>] [-b branch] [-f] [-c] [-w] [-h]"
FREESBB='false'
WEB='false'
CONTROLLER='false'
BRANCH="master"

while getopts ":n:p:k:s:e:t:g:fcwb:h" flag; do
  case "${flag}" in
    n) NAME="${OPTARG}" ;;
    p) PASSWD="${OPTARG}" ;;
    k) KEYFILE=${OPTARG} ;;
    s) SSMTP_CONF=${OPTARG} ;;
    e) EMAIL_SENDER="${OPTARG}" ;;
    t) EMAIL_TO="${OPTARG}" ;;
    g) GITHUB_URL="${OPTARG}" ;;
    c) CONTROLLER='true' ;;
    w) WEB='true' ;;
    f) FREESBB='true' ;;
    b) BRANCH=${OPTARG} ;;
    h) echo "$USAGE"; exit 0 ;;
    *) echo "Unexpected option ${flag}, $USAGE"; exit 42 ;;
  esac
done

if [[ ! $EMAIL_TO ]] && [[ $EMAIL_SENDER ]]; then
    EMAIL_TO=$EMAIL_SENDER
fi

echo "Hostname: $NAME"
echo "Password: $PASSWD"
echo "Keyfile: $KEYFILE"
echo "Ssmtp.conf File: $SSMTP_CONF"
echo "Email Sender: $EMAIL_SENDER"
echo "Email To: $EMAIL_TO"
echo "Branch: $BRANCH"
echo "Freesbb: $FREESBB"
echo "Controller Autostart: $CONTROLLER"
echo "Web Browser Autostart: $WEB"
echo "Update config via Github url: $GITHUB_URL"
echo "Setupdir: $SETUPDIR"

if [[ ! $NAME ]]; then
    echo "Missing parameter -n <hostname>, usage: $USAGE"
    exit 43
fi

if [[ ! $SSMTP_CONF ]] && [[ $EMAIL_SENDER ]]; then
    echo "Missing parameter -s <ssmtp conf file> required if -e <email sender> is set, usage: $USAGE"
    exit 44
fi

wget -q -O- http://www.search.ch >> /dev/null
if [[ $? -ne 0 ]]; then
    echo "No network access, start setup terminated in ERROR"
    exit 11
fi

# stop the anyoing wizzard
echo "removing raspberry wizzard"
sudo kill $(ps aux | grep '[p]iwiz' | awk '{print $2}')
sudo rm /etc/xdg/autostart/piwiz.desktop

echo "setting keyboard"
sudo cp -f $SETUPDIR/controller/default/keyboard /etc/default/keyboard

mkdir -p ~/cimon
if [[ $KEYFILE ]]; then
    echo "Copying key.bin..."
    cp $KEYFILE ~/cimon/key.bin
    CheckReturncode
fi

echo "$BRANCH" > ~/cimon/.git_branch

cd cimon_setup

R="/tmp/cimon_github/cimon_setup"

echo "Starting Setup..."

bash $SETUPDIR/setup_base.sh
CheckReturncode

if [[ $SSMTP_CONF ]]; then
    echo "Setup email..."
    bash $SETUPDIR/setup_email.sh $SSMTP_CONF $EMAIL_SENDER $EMAIL_TO
    CheckReturncode
fi

echo "$CONTROLLER" > ~/cimon/.autostart_controller

echo "Setup controller..."
bash $SETUPDIR/setup_controller.sh
CheckReturncode

echo "Setup autoupdate..."
bash $SETUPDIR/setup_autoupdate.sh
CheckReturncode

# install web page
echo "Setup web..."
echo "$WEB" > ~/cimon/.autostart_browser
bash $SETUPDIR/setup_web.sh
CheckReturncode


# free sbb if not allready installed
if [[ "$FREESBB" == "true" ]] && [[ ! -d /opt/cimon/freesbb ]]; then
    echo "Setup free sbb..."
    bash $SETUPDIR/setup_freesbb.sh
    CheckReturncode
else
    echo "Freesbb not configured"
fi

# update config via github
if [[ $GITHUB_URL  ]]; then
    echo "Setup update config via github..."
    bash $SETUPDIR/setup_update_config.sh $GITHUB_URL
    CheckReturncode
else
    echo "Update config via github not configured"
fi

echo "Setup monitoring..."
bash $SETUPDIR/setup_monitoring.sh
CheckReturncode

if [[ $PASSWD ]]; then
    echo "Chaning password..."
    echo pi:$PASSWD | sudo chpasswd
    if [[ $? ]]; then
        echo "Changed password"
    else
        echo "Failed to change password!"
    fi
fi

echo "Forcing HDMI output on"
sudo bash $SETUPDIR/force_hdmi_on.sh >> /dev/null
CheckReturncode

echo "Adjusting SSL configuration..."
sudo bash $SETUPDIR/patch_ssl_config.sh >> /dev/null
CheckReturncode

echo "Starting ssh daemon..."
sudo bash $SETUPDIR/setup_ssh.sh >> /dev/null
CheckReturncode

bash $SETUPDIR/web/install_disable_screensleep.sh
CheckReturncode

echo "Setting hostname..."
sudo bash $SETUPDIR/set_hostname.sh $NAME >> /dev/null
CheckReturncode

popd

read -n1 -rsp $'Done, press any key to reboot or Ctrl+C to exit...\n'
reboot
