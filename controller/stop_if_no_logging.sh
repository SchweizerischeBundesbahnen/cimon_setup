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
  # kill process as the log file was not modified for at least for $ctime_max
  sudo service cimon stop >> /var/log/cimon/cimon_stdouterr.log 2>&1
fi
