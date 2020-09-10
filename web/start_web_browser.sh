#!/usr/bin/env bash

export DISPLAY=:0.0
URL=http://localhost/

# check for existing browser instances
pgrep chromium > /dev/null
RC=$?

# if browser is not yet running and autostart is configured -> start browser 
if [[ $RC -ne 0 ]] && [[ -f ~/cimon/.autostart_browser ]] && [[ "$(cat ~/cimon/.autostart_browser)" == "true" ]]; then
    #echo "`date`: Chromium not running, starting browser" >> /var/log/cimon/browser_start.log
    chromium-browser --kiosk $URL &
else
    #echo "`date`: Chromium already running, no need to start browser" >> /var/log/cimon/browser_start.log
fi
