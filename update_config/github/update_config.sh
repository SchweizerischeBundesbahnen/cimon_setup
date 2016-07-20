#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# update_config the remote configuration

HN=$(hostname)
BRANCH=config/$HN
WORKSPACE=/tmp/cimon_github/config
URL=$(cat ~/cimon/.update_config_url)

if [[ ! $URL ]]; then
    echo "$(date) Could not find the update_config_url"
    exit 91
fi

pushd .

CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "$(date) Update Config via GIT failend, GIT command returned $RC"
        popd
        if [[ "$1" == "del" ]]; then
            echo "Deleting workspace in case there is an issue"
            rm -rf $WORKSPACE 1>/dev/null 2>&1
        fi
        exit $RC
    fi
}

mkdir -p $WORKSPACE 1>/dev/null 2>&1

# get the newest repo version
if [ ! -d $WORKSPACE/.git ]; then
    echo "$(date) Config was not checked out, cloning into $WORKSPACE"
    mkdir -p $WORKSPACE
    cd $WORKSPACE
    git clone $URL .
    CheckReturncode
    git rev-parse --quiet --verify $BRANCH 1>/dev/null
    if [[ $? -ne 0 ]]; then
        # branch does not exist
        git checkout -b $BRANCH
        CheckReturncode del
        git push origin
        CheckReturncode del
    else
        git checkout $BRANCH
        CheckReturncode del
    fi
else
    echo "$repo is checked out in $WORKSPACE, pulling"
    cd $WORKSPACE
    git fetch origin
    CheckReturncode
    git checkout $BRANCH
    CheckReturncode del
    git diff-index --quiet origin/config/bli
    if [[ $? -ne 0 ]]; then
        # something was changed
        git merge -s recursive -X theirs origin/$BRANCH
        CheckReturncode del
    fi
fi


MYDIR=$(dirname $(readlink -f $0))

# now start the actual update process
$MYDIR/copy_restart_if_changed.sh $WORKSPACE/config
RESTARTED=$?

# write the ip and mac address onto the mydrive
mkdir -p status/$HN
bash $MYDIR/dump_addresses.sh $WORKSPACE/status/$HN > /dev/null 2>&1
CheckReturncode

git add status/$HN/address.txt
CheckReturncode

git diff-index --quiet HEAD
if [[ $? -ne 0 ]]; then
    git commit -m "Changed by update_config.sh on $HN"
    CheckReturncode del
    git push origin
fi

if [[ $RESTARTED -eq 1 ]]; then
    git tag -f -a configured_$HN
    CheckReturncode
    git push -f --tags origin
    CheckReturncode
fi

popd
