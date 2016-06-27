#!/bin/sh
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# Cimon florianseidl 2015
# Start/stop/restart cimon controller

set -e

# Must be a valid filename
NAME=cimon
PIDFILE=/var/run/cimon/cimon.pid
DAEMON=/usr/bin/python3
DAEMON_OPTS="/opt/cimon/controller/cimon.py"
USER=pi
LOGFILE="/var/log/cimon/cimon_stouterr.log"

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"

Start() {
    mkdir -p `dirname $PIDFILE`
    chown $USER `dirname $PIDFILE`
    start-stop-daemon --start --quiet --chuid $USER --background --no-close --make-pidfile --pidfile $PIDFILE --exec $DAEMON -- $DAEMON_OPTS > $LOGFILE 2>&1
}

Stop() {
    start-stop-daemon --stop --quiet --oknodo --retry INT/30/TERM/20/KILL/10 --pidfile $PIDFILE
}

case "$1" in
  start)
        echo -n "Starting daemon: "$NAME
        Start
        echo "."
    ;;
  stop)
        echo -n "Stopping daemon: "$NAME
        Stop
        echo "."
    ;;
  restart)
        echo -n "Restarting daemon: "$NAME
        Stop
        Start
        echo "."
    ;;
  *)
    echo "Usage: "$0" {start|stop|restart}"
    exit 1
esac

exit 0
