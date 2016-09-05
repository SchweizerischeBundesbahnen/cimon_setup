#!/usr/bin/env bash

URL=http://localhost/

pgrep chromium > /dev/null
RC=$?

if [[ $RC -eq 0 ]] && [[ -f ~/cimon/.autostart_web ]] && [[ "$(cat ~/cimon/.autostart_controller)" == "true" ]]; then
    chromium-browser --kiosk --disable-translate $URL &
fi