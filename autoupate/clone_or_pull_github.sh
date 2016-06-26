#!/usr/bin/env bash
WORKSPACE=$1
REPO=$2
if [[ -f ~/cimon/cimon_branch.txt ]]; then
    BRANCH=$(cat ~/cimon/git_branch)
else
    BRANCH="master"
fi
# get the newest repo version
if [ ! -d $WORKSPACE/$REPO ]; then
    mkdir -p $WORKSPACE
    git clone http://github.com/SchweizerischeBundesbahnen/$REPO.git -b $BRANCH
else
    pushd .
    cd $WORKSPACE/$REPO
    git pull
    popd
fi
