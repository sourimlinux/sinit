#!/bin/bash

# SINIT - Sourim Init
# Copyright (C) 2024 r2team
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

failed() {
	echo "$1: failed"
	exit 1
}

service_ctl() {
	chmod +x /etc/sv/exec/$2 || failed $2
	timeout -k 10s 10s /etc/sv/exec/$2 $1 || echo "$1: $2: timeout down"
	echo "$1: $2: ok"
}
stop_all_service() {
	for level in 5 4 3 2 1 0; do
		for sv in `ls /etc/sv/$level/`; do
			service_ctl stop $sv &
		done
	done
	wait
}

case "$1" in
start)
	service_ctl start $2
	;;
stop)
	service_ctl stop $2
	;;
restart)
	service_ctl stop $2 || failed $2
	service_ctl start $2 || failed $2
	;;

reboot)
	stop_all_service || exit 1
	echo b > /proc/sysrq-trigger || exit 1
	;;
shutdown)
	stop_all_service || exit 1
	echo o > /proc/sysrq-trigger || exit 1
	;;
*)
	echo "usage: sv COMMAND OPTIONS"
	echo "  start    <NAME>          Start service"
	echo "  stop     <NAME>          Stop service"
	echo "  restart  <NAME>          Restart service"
	echo "  reboot 				 	 Stop all services. Reboot"
	echo "  shutdown 			 	 Stop all services. Shutdown"
	;;
esac
