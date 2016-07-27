#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
## Chromium installieren
# Siehe https://www.raspberrypi.org/forums/viewtopic.php?t=121195
wget -qO - http://bintray.com/user/downloadSubjectPublicKey?username=bintray | sudo apt-key add -
echo "deb http://dl.bintray.com/kusti8/chromium-rpi jessie main" | sudo tee -a /etc/apt/sources.list
sudo apt-get -y update
sudo apt-get -y install chromium-browser
