#!/usr/bin/env bash
retry_count=0
wget -q -O- http://www.search.ch >> /dev/null
while [[  $? -ne 0 ]]; do
    if [[ $retry_count -ge 7 ]]; then
        echo "Could not establish network connection..."
        exit 42
    fi
    sudo service networking restart
    # maybe its free sbb, try to press the accept button if required
    if [ -f /opt/cimon/freesbb/freesbb.py ]; then
        python3 /opt/cimon/freesbb/freesbb.py > /dev/null
    fi
    let retry_count=retry_count+1
    sleep $(($retry_count * 3))s
    wget -q -O- http://www.search.ch > /dev/null
done
exit 0