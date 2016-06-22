#!/usr/bin/env bash
# Setup everything from an usb stick packed by pack_usb_stick

usbstick=$(dirname $(readlink -f $0))

if [[ ! $1 || ! $2 || ! $3 ]]; then
    echo "3 Parameters <hostname> <mydrive_user> <mydrive_password> required"
    exit 3
fi

wget -q -O- http://www.search.ch >> /dev/null
if [[ $? -ne 0 && -f $usbstick/setup_freesbb ]]; then
    echo "Setup free sbb in order to establish network connection..."
    bash $usbstick/setup_freesbb.sh
    read -n1 -rsp $'Wait for the network connection to be established and press any key to continue if its OK or Ctrl+C to exit...\n'
fi

mkdir -p ~/cimon
if [[ -f $usbstick/key.bin ]]; then
    echo "Copying key.bin..."
    cp $usbstick/key.bin ~/cimon/key.bin
fi

pushd .

mkdir -p /tmp/cimon_github
cd /tmp/cimon_github
if [[ ! $CIMON_BRANCH ]]; then
    CIMON_BRANCH="master"
fi
git clone https://github.com/SchweizerischeBundesbahnen/cimon_setup.git -b $CIMON_BRANCH

cd cimon_setup
echo "Set hostname..."
sudo bash ./set_hostname.sh $1 >> /dev/null
echo "Setup..."
bash ./setup.sh

# free sbb update config
echo "Setup update config..."
bash ./setup_update_config.sh $2 $3
# free sbb if not allready installed
if [[ ! -d /opt/cimon/freesbb ]]; then
    echo "Setup free sbb..."
    bash ./setup_freesbb.sh
fi

popd