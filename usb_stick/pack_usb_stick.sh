#!/usr/bin/env bash
if [[ ! $1 || ! -d $1 ]]; then
    echo "1 parameters required: USB Stick mount directory, 1 optional parameter: key file with path"
    exit 5
fi
copy -f start_setup_all.sh $1
rm -rf $1/freesbb
rm -f $1/setup_freesbb.sh
mkdir $1/freesbb
copy -r ../freesbb $1/freesbb
copy -f ../setup_freesbb.sh $1
if [[ $2 ]]; then
    copy -f $2 $1
fi