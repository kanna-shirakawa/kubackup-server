# kubackup-server
KUBiC Labs rsync network backup

WIP: just loading the project here from original package

from debian/control description:

kubackup is a network backup system, based on rsync; is tailored for
Linux systems, but with some limitations can backup Windows(tm)
machines too (ie: using DeltaCopy porting of rsync), and potentially
every system that can make use of rsync program

kubackup is fast, uses external disks for storage (tipically USB
disks), efficently manage incremental backups, copies can be shared
using samba with the same permission of original shares, so users
can restore individual files by themself if needed

it's designed to work unattended, sends detailed reports via email,
and can run on very low power machine (ie: appliances), the
perfect solution for building small, affordable, drop-and-run
backup machines

note: actually it misses a console management (ie: a web based one),
all the setup and management must be done via ssh; the best way
to manage it is using kusa integration

note: this package uses 'mirror' command, from ku-file-utils package;
if you want to avoid ku-file-utils dependendacy, a copy of 'mirror'
script is the documentation directory

---

# releases

you can get prebuilt .deb packages from here: https://repos.kubit.ch

---

# note

The original projects started a lot of time ago, and I was not fluent
in english, so ... the internal comments and (*gasp!*) the manpages
are in italian only, and somewhat outdated. Hope to have time to
fix this mess.
