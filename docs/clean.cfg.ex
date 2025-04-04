# COPY THIS FILE TO CONFIG DIR, REMOVING THE '.ex' SUFFIXES
#
# config file for clan_disk kubackup-run plugin
#
# each line of the config file contains these fields, separated by
# spaces or tabs:
#
#	label_match	min_size	dir_match(es)
#
#	MYBACKUP[0-9]*	10000		oldsys* tempserver*
#	MYBACKUP[0-9]*	-		slot/anothersys-[0-9]*
#
# - matches uses shell glob expansions
# - all after '#' character is comment, empty lines are discarted
# - labels are matched against LABEL_<label_match>
# - dir_matches are relative to disk mountpoint
# - min_size is in Mb, if 0 or '-' (minus) is ignored (atm like a comment),
#   otherwise directory purge occurs only if free space on disk (in Kb) is
#   below the min_size parameter
#
#MYBACKUP[0-9]*	200000	server1 server1_*
#MYBACKUP[0-9]*	80000	server2 server2_* slot/server3 slot/server3_*

# OTHER PARMS

# cleanup of old logfiles in __kubackup metadata directory on disk
#
MAX_LOGFILES_AGE=0	# in days, zero or empty means no cleanuyp
