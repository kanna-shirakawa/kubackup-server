# /etc/kubackup/mysystem_modules - sample backup modules file for 'mysystem'
#
# note that each 'module' must match the module name defined on the remote
# system (see rsyncd.conf docs for details); dir paths are relative to the
# path as declared in module entry on the remote system
#
#
#module		dir			user	passwd	args
#-------------	-----------------------	-------	-------	--------------------------
C		Documents^and^Settings	name	secret
D		/			name	secret	--exclude=/DontBackup


# this is a linux entry sample, we set the 'L' flag
#
data,L		/			name	secret

# here we backup the 'work' partition, but on 'specialprojet' subdir we want to
# copy temp, cache, etc fiels, too, so we disable mirror command 'clean'
# exclusions # (run mirror --help for details), using the 'A' flag
#
work,L		/			name	secret	--exclude=specialproject/*
work,LA		/specialproject		name	secret

# on this entry we set a custom timeout, overriding the system default, using
# the T=timespec flag
#
dumps,LT=4h	/slot2/bigdumps		name	secret
