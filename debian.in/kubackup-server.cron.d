# /etc/cron.d/kubackup-server
#
# in this example kubackup runs every day, at 13 only for
# local systems (group "local"), and at 1 for all systems
#
#0 13 * * * root /usr/sbin/kubackup-run -g local
#0  1 * * * root /usr/sbin/kubackup-run
