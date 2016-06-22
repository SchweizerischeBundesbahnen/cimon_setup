#!/usr/bin/env bash
if [[ ! $1 || ! -d $1 ]]; then
    echo "1 parameters required: USB Stick mount directory, optional second parameter 'freesbb' if freesbb is desired"
    exit 5
fi
copy -f start_setup_all.sh $1
rm -rf $1/freesbb
rm -f $1/setup_freesbb.sh
if [[ "$1" -eq "freesbb" ]]; then
    mkdir $1/freesbb
    copy -r ../freesbb $1/freesbb
    copy -f ../setup_freesbb.sh $1
fi