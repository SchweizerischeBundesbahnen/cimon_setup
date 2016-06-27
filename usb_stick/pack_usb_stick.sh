#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# cimon, SBB, FSe 2016
if [[ ! $1 ]]; then
    echo "1 parameters required: USB Stick mount directory, 2 optional parameters: key file with path, start script with path"
    exit 5
fi

if [[ ! -d $1 ]]; then
    echo "Path $1 not found"
    exit 6
fi

copy -f start_setup.sh $1
rm -rf $1/freesbb
mkdir $1/freesbb

copy -r ../freesbb $1/freesbb
copy -f ../setup_freesbb.sh $1

if [[ $2 ]]; then
    copy -f $2 $1
fi

if [[ $3 ]]; then
    copy -f $3 $1
fi