# /usr/lib/kubackup/pre-post-common.sh
#
# __copy1__
# __copy2__
#
# kubackup pre/post common functions and bootstrap code
# v1.1 (2022-12-20)
#
# this file must be included before any other custom code

export CONFDIR F_EXEC SYSTEMS VERBOSE CMD


# calls logging function prepending script name tag
#
mylog()
{
	CMD=${CMD:-$(basename "$0")}
        ku_log "    [$CMD] $*"
}



# set defaults for standalone runs (ie: for debug/testing)
#
# on standalone invokation, arguments are used as system list
# (formerly, as kubackup-systems arguments, see kubackup-systems
# usage for details); first argument is used as config file if 
# a full path is detected
#
#	./scriptname [/tmp/myconfig.conf] [system-list ...]
#
# F_EXEC is set to "false", if you want to run in exec mode
# use the syntax
#
#	F_EXEC=true ./scriptname ...
#
f_standalone=false

[ "X${CONFDIR:-}" == "X" ] && {
	f_standalone=true
	export CONFDIR="/etc/kubackup"
	export F_EXEC=${F_EXEC:-"false"}
	export VERBOSE="true"
	export LOGSYSLOG="false"
	export CfgFile="/etc/kubackup-run.conf"
	. "$CfgFile"
	case ${1:-} in
	  /*) CfgFile=$1; shift ;;
	esac
	. "$CfgFile"
	export SYSTEMS=$(echo $(kubackup-systems --config "$CfgFile" "$@"))
	echo -e "\n*** running in standalone mode F_EXEC=$F_EXEC CfgFile=$CfgFile ***\n"
}

. /lib/ku-base/log.sh

# (EOF) /usr/lib/kubackup/pre-post-common.sh
