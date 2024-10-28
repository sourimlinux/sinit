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

case "$1" in
start)
	chmod +x /etc/sv/exec/$2 || failed $2
	/etc/sv/exec/$2 start || failed $2
	echo "start: $2: ok"
	;;
stop)
	chmod +x /etc/sv/exec/$2 || failed $2
	/etc/sv/exec/$2 stop || failed $2
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
