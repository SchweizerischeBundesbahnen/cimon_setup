#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
WORKSPACE=$1
REPO=$2
if [[ -f ~/cimon/git_branch ]]; then
    BRANCH=$(cat ~/cimon/git_branch)
else
    BRANCH="master"
fi

pushd .

# get the newest repo version
if [ ! -d $WORKSPACE/$REPO ]; then
    mkdir -p $WORKSPACE
    cd $WORKSPACE
    git clone http://github.com/SchweizerischeBundesbahnen/$REPO.git -b $BRANCH
else
    cd $WORKSPACE/$REPO
    git pull
fi

popd
