#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2020
# mail the current state from the logs regularily

if ! [[ -f ~/cimon/.mailto ]]; then
    echo "No mailto address defined, not sending mail"
    exit 0
fi

SUBJECT=$1
TO=$(cat ~/cimon/.mailto)
FROM=$(cat /etc/ssmtp/ssmtp.conf | grep "root" | cut -d'=' -f2)
if [[ "$FROM" == "" ]]; then
    FROM=$(cat /etc/ssmtp/ssmtp.conf | grep "AuthUser" | cut -d'=' -f2)
fi

TEXT=""
if [ -p /dev/stdin ]; then
    while IFS= read -r line; do
        TEXT="$TEXT${line}\n"
    done
fi

echo "Sending mail from $FROM to $TO: $TEXT"
echo -e $TEXT | mail -a "From: $FROM" -s "$SUBJECT" $TO