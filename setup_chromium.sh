#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016

echo "$(date) Starting setup chromium..."
SETUPDIR=$(dirname $(readlink -f $0))

echo "$(date) Installing chromium..."
# Chromium Browser
bash $SETUPDIR/chromium/install_chromium.sh
CheckReturncode
echo "$(date) Chromium installed"

echo "$(date) Setup chromium terminated OK"