#!/bin/bash

failed() {
	echo "$1: failed"
	exit 1
}

case "$1" in
start)
	/var/service/$2/start || failed $2
	echo "start: $2: ok"
	;;
stop)
	/var/service/$2/stop || failed $2
	echo "stop:  $2: ok"
	;;
restart)
	$0 stop $2 || failed $2
	$0 start $2 || failed $2
	;;
*)
	echo "usage: sv start|stop|restart NAME"
	;;
esac
