#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# this is the only script that can not be distributed using the update_config mechanism...
# it would be like muenchhausen
scriptdir=$(dirname $(readlink -f $0))

bash $scriptdir/clone_or_pull_github /tmp/cimon_github cimon_setup
bash /tmp/cimon_github/cimon_setup/update.sh


