#!/usr/bin/env bash
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

USAGE="Usage: -n <hostname> [-m] [-u <mydrive_user> -p <mydrive_password>] [-b branch] [-f] [-h]"
MYDRIVE='false'
FREESBB='false'
BRANCH="master"

while getopts ":n:mu:p:b:fh" flag; do
  case "${flag}" in
    n) NAME="${OPTARG}" ;;
    m) MYDRIVE='true' ;;
    u) MYDRIVE_USER="${OPTARG}" ;;
    p) MYDRIVE_PASSWORD="${OPTARG}" ;;
    f) FREESBB='true' ;;
    b) BRANCH=${OPTARG} ;;
    h) echo "$USAGE"; exit 0 ;;
    *) echo "Unexpected option ${flag}, $USAGE"; exit 42 ;;
  esac
done

echo "Hostname: $NAME"
echo "Branch: $BRANCH"
echo "Freesbb: $FREESBB"
echo "Mydrive: $MYDRIVE"
echo "Mydrive user: $MYDRIVE_USER"
echo "Mydrive password: $MYDRIVE_PASSWORD"

if [[ ! $NAME ]]; then
    echo "Missing parameter -n <hostname>, usage: $USAGE"
    exit 43
fi

if [[ "$MYDRIVE" == "true" && ( ! $MYDRIVE_USER || ! $MYDRIVE_PASSWORD ) ]]; then
    echo "Paramterer mydrive -m set, but parameters -u <mydrive_user> and/or -p <mydrive_password> missing. Usage: $USAGE"
    exit 44
fi

usbstick=$(dirname $(readlink -f $0))
echo "Starting Setup from $usbstick ..."

wget -q -O- http://www.search.ch >> /dev/null
if [[ $? -ne 0 && "$FREESBB" == "true" ]]; then
    echo "Setup free sbb in order to establish network connection..."
    bash $usbstick/setup_freesbb.sh
    CheckReturncode
    read -n1 -rsp $'Wait for the network connection to be established and press any key to continue if its OK or Ctrl+C to exit...\n'
fi

mkdir -p ~/cimon
if [[ -f $usbstick/key.bin ]]; then
    echo "Copying key.bin..."
    cp $usbstick/key.bin ~/cimon/key.bin
fi

mkdir -p /tmp/cimon_github
cd /tmp/cimon_github

echo "$BRANCH" > ~/cimon/git_branch
git clone https://github.com/SchweizerischeBundesbahnen/cimon_setup.git -b $BRANCH

cd cimon_setup

DIR="/tmp/cimon_github/cimon_setup"

echo "Setup..."
bash $DIR/setup.sh
CheckReturncode

# free sbb update config
if [[ "$MYDRIVE" == "true"  ]]; then
    echo "Setup update config via mydrive..."
    bash $DIR/setup_update_config.sh $MYDRIVE_USER $MYDRIVE_PASSWORD $NAME
    CheckReturncode
fi

# free sbb if not allready installed
if [[ "$FREESBB" == "true" && ! -d /opt/cimon/freesbb ]]; then
    echo "Setup free sbb..."
    bash $DIR/setup_freesbb.sh
    CheckReturncode
fi

echo "Set hostname..."
sudo bash $DIR/set_hostname.sh $1 >> /dev/null
CheckReturncode

popd

read -n1 -rsp $'Done, press any key to reboot or Ctrl+C to exit...\n'
reboot