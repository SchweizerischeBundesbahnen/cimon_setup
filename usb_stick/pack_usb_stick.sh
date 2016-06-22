#!/usr/bin/env bash
if [[ ! $1 || ! -d $1 ]]; then
    echo "1 parameters required: USB Stick directory"
    exit 5
fi
rm -rf $1/freesbb
mkdir $1/freesbb
copy -r ../freesbb $1/freesbb
copy -f start_sbb_setup.sh $1