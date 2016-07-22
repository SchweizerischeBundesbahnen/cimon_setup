#!/usr/bin/env bash
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

USAGE="Usage: -n <hostname> [-p <password>] [-e <email sender>] [-t <send monitoring email to address>] [-g <config github_url>] [-b branch] [-f] [-w] [-h]"
FREESBB='false'
WEB='false'
BRANCH="master"

while getopts ":n:p:e:t:g:fwb:h" flag; do
  case "${flag}" in
    n) NAME="${OPTARG}" ;;
    p) PASSWD="${OPTARG}" ;;
    e) EMAIL_SENDER="${OPTARG}" ;;
    t) EMAIL_TO="${OPTARG}" ;;
    g) GITHUB_URL="${OPTARG}" ;;
    w) WEB='true' ;;
    f) FREESBB='true' ;;
    b) BRANCH=${OPTARG} ;;
    h) echo "$USAGE"; exit 0 ;;
    *) echo "Unexpected option ${flag}, $USAGE"; exit 42 ;;
  esac
done

if [[ ! $EMAIL_TO && $EMAIL_SENDER ]]; then
    EMAIL_TO=$EMAIL_SENDER
fi

echo "Hostname: $NAME"
echo "Password: $PASSWD"
echo "Email Sender: $EMAIL_SENDER"
echo "Email To: $EMAIL_TO"
echo "Branch: $BRANCH"
echo "Freesbb: $FREESBB"
echo "Web: $WEB"
echo "Update config via Github url: $GITHUB_URL"

if [[ ! $NAME ]]; then
    echo "Missing parameter -n <hostname>, usage: $USAGE"
    exit 43
fi

USBSTICK=$(dirname $(readlink -f $0))
echo "Starting Setup from $USBSTICK ..."

wget -q -O- http://www.search.ch >> /dev/null
if [[ $? -ne 0 && "$FREESBB" == "true" ]]; then
    echo "Setup free sbb in order to establish network connection..."
    bash $USBSTICK/setup_freesbb.sh
    CheckReturncode
    read -n1 -rsp $'Wait for the network connection to be established and press any key to continue if its OK or Ctrl+C to exit...\n'
fi

wget -q -O- http://www.search.ch >> /dev/null
if [[ $? -ne 0 ]]; then
    echo "No network access, start setup terminated in ERROR"
    exit 11
fi

mkdir -p ~/cimon
if [[ -f $USBSTICK/key.bin ]]; then
    echo "Copying key.bin..."
    cp $USBSTICK/key.bin ~/cimon/key.bin
fi

mkdir -p /tmp/cimon_github
cd /tmp/cimon_github

echo "$BRANCH" > ~/cimon/.git_branch
git clone https://github.com/SchweizerischeBundesbahnen/cimon_setup.git -b $BRANCH

cd cimon_setup

DIR="/tmp/cimon_github/cimon_setup"

echo "Setup..."
bash $DIR/setup.sh
CheckReturncode

if [[ -f $USBSTICK/ssmtp.conf && $EMAIL_SENDER ]]; then
    echo "Setup email..."
    bash $DIR/setup_email.sh $USBSTICK/ssmtp.conf $EMAIL_SENDER $EMAIL_TO
    CheckReturncode
fi

# install web page
if [[ "$WEB" == "true" ]]; then
    echo "Setup web..."
    bash $DIR/setup_web.sh
    CheckReturncode
fi

# free sbb if not allready installed
if [[ "$FREESBB" == "true" && ! -d /opt/cimon/freesbb ]]; then
    echo "Setup free sbb..."
    bash $DIR/setup_freesbb.sh
    CheckReturncode
else
    echo "Freesbb not configured"
fi

# update config via github
if [[ $GITHUB_URL  ]]; then
    echo "Setup update config via github..."
    bash $DIR/setup_update_config.sh $GITHUB_URL
    CheckReturncode
else
    echo "Update config via github not configured"
fi

if [[ $PASSWD ]]; then
    echo "Chaning password..."
    echo pi:$PASSWD | sudo chpasswd
    if [[ $? ]]; then
        echo "Changed password"
    else
        echo "Failed to change password!"
    fi
fi

echo "Setting hostname..."
sudo bash $DIR/set_hostname.sh $NAME >> /dev/null
CheckReturncode

popd

read -n1 -rsp $'Done, press any key to reboot or Ctrl+C to exit...\n'
reboot