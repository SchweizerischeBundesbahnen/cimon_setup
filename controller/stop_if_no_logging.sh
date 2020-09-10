#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2020

LOG_FILE=/var/log/cimon/cimon.log
# 25 hours
MAX_TIME_NO_LOG_SEC=90000

# check last log modification time
ctime="$(ls ${LOG_FILE} --time=ctime -l --time-style=+%s | awk '{ print $6 }')"
ctime_current="$(date +%s)"
ctime_diff="$((ctime_current-ctime))"
# if there was nothing written into the log in the last 25 hours, stop the service
if [ "${ctime_diff}" -gt "${MAX_TIME_NO_LOG_SEC}" ]; then
  echo "$(date) there was no logging to ${LOG_FILE} for more than 25 hours. Stopping cimon service." >> /var/log/cimon/cimon_stdouterr.log
  sudo service cimon stop >> /var/log/cimon/cimon_stdouterr.log 2>&1
  echo "$(date) Cimon service stopped (at least tried to do so)" >> /var/log/cimon/cimon_stdouterr.log
  sudo service cimon status >> /var/log/cimon/cimon_stdouterr.log2>&1
fi
