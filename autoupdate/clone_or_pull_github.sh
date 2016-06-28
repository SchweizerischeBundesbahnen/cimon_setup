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
    echo "$repo was not checked out, cloning into $WORKSPACE"
    mkdir -p $WORKSPACE
    cd $WORKSPACE
    git clone http://github.com/SchweizerischeBundesbahnen/$REPO.git -b $BRANCH
else
    echo "$repo is checked out in $WORKSPACE/$REPO, pulling"
    cd $WORKSPACE/$REPO
    git pull
fi

popd
