#!/usr/bin/env bash

URL=http://localhost/

pgrep chromium > /dev/null
RC=$?

if [[ $RC -eq 0 ]] && [[ -f ~/cimon/.autostart_browser ]] && [[ "$(cat ~/cimon/.autostart_browser)" == "true" ]]; then
    chromium-browser --kiosk --disable-translate $URL &
fi