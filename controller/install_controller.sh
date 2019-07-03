#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
## Cimon controller scripts installieren
SETUPDIR=$(dirname $(readlink -f $0))
# Vorrausetzung: Python module
#PyYaml: https://pypi.python.org/pypi/PyYAML
sudo apt-get install python3-yaml
sudo pip3 install pyaes
sudo pip3 install phue
# Cimon controller scripts
# verwenden Python3 (vorinstalliert)
# start-stopscript installieren
sudo mkdir -p /var/log/cimon
sudo chmod a+rwx /var/log/cimon

# install the start/stop scripts
bash $SETUPDIR/update_start_stop_watchdog.sh

# install the python application
bash $SETUPDIR/update_controller.sh
