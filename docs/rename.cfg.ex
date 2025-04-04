# /etc/kubackup/rename.cfg - sample config file for NNrename pre.d script

# 'system' refers to the REAL system directory as stored on backup disk, 
# not the logical name that you have used to define it (aka the config
# name); to be precise, there is no need to have the system defined at
# all, because the script works merely on directories on disk
#
# remember this rule, expecially if you have set a custom slot
#
# 'system' is used to match any occurrence on disk, so if the rotations
# are activated will match any 'system_DATESTAMP' directory

# 3 fields, per-system directory rename
#
# SYSTEM	FROM_DIR	TO_DIR
mysystem	_dir1		_newdir1
slot1/asystem	_a_dir_name	_new_name


# 2 fields, system rename
#
# FROM_SYSTEM	TO_SYSTEM
system1		newname1
system2		new_slot/system2
system3		new_slot/system3-renamed

