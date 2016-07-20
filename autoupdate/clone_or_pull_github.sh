#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
WORKSPACE=$1
REPO=$2
if [[ -f ~/cimon/.git_branch ]]; then
    BRANCH=$(cat ~/cimon/.git_branch)
else
    BRANCH="master"
fi

RC=0

pushd .

# get the newest repo version
#
# first, pull if the checkout directory allready exists
if [ -d $WORKSPACE/$REPO ]; then
    echo "$repo is checked out in $WORKSPACE/$REPO, pulling"
    cd $WORKSPACE/$REPO
    git pull origin 1>/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        # may be an issue with the workspace, in any case just elimate it to be safe
        echo "Error pulling $WORKSPACE/$REPO, removing workspace"
        cd .. # go out of the dir to be deleted
        rm -rf $WORKSPACE/$REPO 1>/dev/null 2>&1
    fi
fi
# then if it did not exist or was just deleted, clone
if [ ! -d $WORKSPACE/$REPO ]; then
    echo "$repo was not checked out, cloning into $WORKSPACE"
    mkdir -p $WORKSPACE
    cd $WORKSPACE
    git clone http://github.com/SchweizerischeBundesbahnen/$REPO.git -b $BRANCH
    RC=$?
fi

popd

exit $RC