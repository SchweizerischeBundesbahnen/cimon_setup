#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2020
# Sicherstellen, das der Bildschirm nicht in den Schlafmodus übergeht

DMCONF=/etc/lightdm/lightdm.conf

if ! grep -q '^xserver-command=X -s 0 dpms' $DMCONF; then
    # avoid sleep...
    TMPFILE=~/lightdm.conf.tmp
    cp $DMCONF $TMPFILE
    CHAPTER='[Seat:*]'
    LINE='#avoid the screen sleeping\nxserver-command=X -s 0 dpms'
    sed -i 's/$CHAPTER/$CHAPTER\n$LINE/g' $TMPFILE
    sudo mv $DMCONF $DMCONF.orig
    sudo mv $TMPFILE $DMCONF
    sudo chown root $DMCONF
    sudo chmod u=rw,g=r,o=r $DMCONF
fi