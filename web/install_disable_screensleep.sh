#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2020
# Sicherstellen, das der Bildschirm nicht in den Schlafmodus übergeht
SETUPDIR=$(dirname $(readlink -f $0))
DMCONF=/etc/lightdm/lightdm.conf

# avoid sleep...
sudo mv $DMCONF $DMCONF.orig
sudo cp -f $SETUPDIR/lightdm/lightdm.conf $DMCONF
sudo chown root $DMCONF
sudo chmod u=rw,g=r,o=r $DMCONF
