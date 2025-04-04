#!/bin/bash
#
CMD=$(basename "$0")

set -e -u

do_var()
{
	if [ -f ${1}_$2 ]
	then
		val=$(cat ${1}_$2); val=$(echo $val)
		echo "$2='$val'"
	else
		echo "#$2="
	fi
	return 0
}

ls *_uuid >/dev/null 2>/dev/null || {
	echo "
		THERE ARE NOT *_uuid FILES HERE
		DIRECTORY ALREADY CONVERTED?
"
	exit 1
}


bckfile="/etc/backup/etc-$(basename $(pwd)).tar.gz"

echo -en "
	READY TO CONVERT CONFIGS, WILL PROCESS ALL <sys>_uuid FILES,
	CONVERTING IN <sys>.conf AND REMOVES ALL OLD FORMAT DEFINITIONS

	THE FILES BELOW, IF PRESENT, WILL BE LEFT UNTOUCHED:

		<sys>_modules
		<sys>_disabled
		<sys>_excludes

	A BACKUP WILL BE PERFORMED BEFORE PROCEEDING, THE BACKUP FILE
	IS $bckfile

	PRESS [Return] TO CONTINUE, OR Ctrl-C TO ABORT: "
read trush

# backup first ...
echo -en "\n  backup in $bckfile ... "
tar cfz "$bckfile" .
echo -e "done\n"

for sys in $(ls *_uuid 2>/dev/null)
do
	sys=${sys/_uuid/}
	out=$sys.conf

	(
		echo "# $(pwd)/$out"
		echo "#"
		echo "# converted by $CMD on $(date)"
		echo "#"
		do_var $sys uuid
		echo "address='$sys'"
		[ -f ${sys}_disabled ] && echo '#disabled=true'
		do_var $sys allow
		do_var $sys groups
		do_var $sys rotations
		do_var $sys slot
		do_var $sys precedence
		do_var $sys timeout
	) >$out

	for key in uuid allow groups rotations slot precedence timeout
	do
		rm -f ${sys}_$key
	done

	echo " converted $out"
done

echo "
DONE
"
exit 0
