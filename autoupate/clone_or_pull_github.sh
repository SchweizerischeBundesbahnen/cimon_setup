#!/usr/bin/env bash
WORKSPACE=$1
REPO=$2
if [[ ! $CIMON_BRANCH ]]; then
    CIMON_BRANCH="master"
fi
# get the newest repo version
if [ ! -d $WORKSPACE/$REPO ]; then
    mkdir -p $WORKSPACE
    git clone http://github.com/SchweizerischeBundesbahnen/$REPO.git -b $CIMON_BANCH
else
    pushd .
    cd $WORKSPACE/$REPO
    git pull
    popd
fi
