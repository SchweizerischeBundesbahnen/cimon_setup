#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# configure email on the raspberry using ssmtp

if [[ ! $1 ]] || [[ ! $2 ]] || [[ ! $3 ]]; then
    echo "2 parameters required: ssmtp.conf file with path, email sender and destination email address"
    exit 27
fi

SSMTP_CONF_FILE=$1
EMAIL_SENDER=$2
EMAIL_TO=$3

if [[ ! -f $SSMTP_CONF_FILE ]]; then
    echo "File $SMTP_CONF_FILE not found"
    exit 28
fi

CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "$(date) Setup email terminated in ERROR"
        exit $RC
    fi
}

echo "$(date) Setting up email..."

sudo DEBIAN_FRONTEND=noninteractive apt-get -y install ssmtp
CheckReturncode
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install mailutils
CheckReturncode

echo "Copying ssmtp.conf..."
sudo cp -f $SSMTP_CONF_FILE /etc/ssmtp/ssmtp.conf

# requried so we put the correct from (nowadays a must else the mail is rejected)
sudo EMAIL_SENDER=$EMAIL_SENDER bash -c 'echo "pi:$EMAIL_SENDER" > /etc/ssmtp/revaliases'

echo "$EMAIL_TO" > ~/cimon/.mailto

echo "$(date) Setup email terminated OK"
