#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# monitoring the remote configuration

HN=$(hostname)
BRANCH=config/$HN
WORKSPACE=/tmp/cimon_github/config
URL=$(cat ~/cimon/.update_config_url)
MYDIR=$(dirname $(readlink -f $0))

if [[ ! $URL ]]; then
    echo "$(date) Could not find the update_config_url (~/cimon/.update_config_url)"
    exit 91
fi

pushd .

CheckReturncode() {
    RC=$?
    if [[ $RC -ne 0 ]]; then
        echo "$(date) Update Config via GIT failend, GIT command returned $RC"
        popd
        if [[ "$1" == "del" ]]; then
            echo "$(date) Deleting workspace in case there is an issue"
            rm -rf $WORKSPACE 1>/dev/null 2>&1
        fi
        SendMail "Config Update Failed" "$(tail -99l /var/log/cimon/update_config.log)"
        exit $RC
    fi
}

SendMail() {
    echo -e "$2" | bash $MYDIR/../monitoring/send_mail.sh "CIMON $HN: $1"
}

git config --global user.name $HN
git config --global user.email cimon@fantas.ie
git config --global push.default simple

mkdir -p $WORKSPACE 1>/dev/null 2>&1

# get the newest repo version
if [ ! -d $WORKSPACE/.git ]; then
    echo "$(date) Config was not checked out, cloning into $WORKSPACE"
    mkdir -p $WORKSPACE
    cd $WORKSPACE
    git clone $URL .
    CheckReturncode
    git rev-parse --quiet --verify origin/$BRANCH 1>/dev/null
    if [[ $? -ne 0 ]]; then
        # branch does not exist
        git checkout -b $BRANCH
        CheckReturncode del
        git push --set-upstream origin $BRANCH
        CheckReturncode del
   else
        git checkout $BRANCH
        CheckReturncode del
    fi
else
    echo "$(date) $repo is checked out in $WORKSPACE, pulling"
    cd $WORKSPACE
    git checkout $BRANCH 1>/dev/null
    CheckReturncode del
    git fetch origin
    CheckReturncode
    git diff-index --quiet origin/$BRANCH 1>/dev/null
    if [[ $? -ne 0 ]]; then
        # something was changed
        git merge -s recursive -X theirs origin/$BRANCH
        CheckReturncode del
    fi
fi

# now start the actual update process
$MYDIR/copy_restart_if_changed.sh $WORKSPACE/config
RC=$?
if [[ $RC -eq 0 ]] || [[ $RC -eq 1 ]]; then
    RESTARTED=$RC
else
    SendMail "Failed to udpate configuration" "Configuration was propably invalid ($RC), log:\n\n-----update_config.log-----\n$(tail -99l /var/log/cimon/update_config.log)"
    exit $RC
fi

if [[ $RESTARTED -eq 1 ]]; then
    SendMail "Updated Config" "The configuration on $HN was updated at $(date), new config:\n\n$(cat ~/cimon/cimon.yaml)"
fi

popd
