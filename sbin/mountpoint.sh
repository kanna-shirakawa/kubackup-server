#!/bin/sh
#
#	script version of mountpoint command, muse be used on
#	systems that not provide it natively (rename or copy
#	this script as /bin/mountpoint)
#
#	note: only -q option is emulated
#
# __copy1__
# __copy2__
#
CMD="mountpoint"
CMDVER="1.0"
CMDSTR="$CMD v$CMDVER (2018/08)"
VERBOSE=true

# (MAIN)

[ "X$1" = "X-q" ] && {
	VERBOSE=false
	shift
}

[ $# != 1 ] && {
	echo >&2
	echo "== $CMDSTR == script emulated mountpoint command ==" >&2
	echo >&2
	echo "usage: $CMD [-q] path" >&2
	echo >&2
	exit 127
}

[ -e "$1" ] || {
	echo "$CMD: $1: No such file or directory" >&2
	exit 1
}

awk '{ print $2; }' /proc/mounts | grep -q "^$1$" || {
	$VERBOSE && echo "$1 is not a mountpoint"
	exit 1
}

$VERBOSE && echo "$1 is a mountpoint"
exit 0
