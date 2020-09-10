#!/usr/bin/env bash

URL=http://localhost/

# check for existing browser instances
pgrep chromium > /dev/null
RC=$?

# if browser is not yet running and autostart is configured -> start browser 
if [[ $RC -ne 0 ]] && [[ -f ~/cimon/.autostart_browser ]] && [[ "$(cat ~/cimon/.autostart_browser)" == "true" ]]; then
    chromium-browser --kiosk --disable-translate $URL &
fi
