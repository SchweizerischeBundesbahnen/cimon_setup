#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# this is the only script that can not be distributed using the update_config mechanism...
# it would be like muenchhausen
SCRIPTDIR=$(dirname $(readlink -f $0))

bash $SCRIPTDIR/clone_or_pull_github.sh /tmp/cimon_github cimon_setup
bash /tmp/cimon_github/cimon_setup/update.sh


