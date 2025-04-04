#!/usr/bin/perl -w
#
# __copy1__
# __copy2__

require "./cgilib.pl";
use URI::Escape;
use Socket;
use IO::Socket;

my $CMD		= "backup-status";
my $CMDVER	= "3.2";
my $CMDSTR	= "$CMD v$CMDVER (2020/07)";

my $System;	# the system where we want to get backup status infos
my @Config;
my $Title;
my $Meta;
my $RemoteVersion;

# html page buffers
#
my $buf	= "";	# html page buffer
my $dbgbuf = "";


# defaults
#
$System		= `uname -n`; chomp( $System );

# split incoming arguments
#
my ($key, $val);
my %args	= getcgivars();

if (defined $args{'system'}) {
	$System		= $args{'system'};
}
if (defined $args{'conf'}) {
	@Config	= split( ',', $args{'conf'} );
}

pdebug( "called with System='%s', Configs='%s'\n", $System, join( ", ", @Config ) );

# get target system address
#
my $SysAddr	= gethostbyname( $System );
if (!defined $SysAddr) {
	HTMLdie( sprintf( "cannot get system '%s' address", $System ), $Title, $Meta );
}

# set up css and title
#
$Meta	= '<link href="/css/klabs-report-styles.css" type="text/css" rel="stylesheet" />';
$Title	= sprintf( "%s - %s", $System, inet_ntoa( $SysAddr ) );

# get the remote command version
#
$RemoteVersion = get_remote_version();

# get the configs list if not passed as parms
#
if (scalar(@Config) == 0) {
	get_configs_list();
}

$buf .= sprintf( '
 <div class="header">
 <h1>%s</h1>
  <div class="subtitle">Backup Status</div>
  </div>

  <br clear="all" />
  <div class="col">
', $Title );

my $conf;
for $conf (@Config) {
	$buf .= "  <div class=\"infoTable\">\n";
	$buf .= get_backup_status( $conf );
	$buf .= "  </div>\n\n";
}

$buf .= "<hr>\n";
$buf .= sprintf( "<font size=\"-2\">-- %s</font><br>\n", $CMDSTR );
$buf .= sprintf( "<font size=\"-2\">-- service: %s</font><br>\n", $RemoteVersion );

HTMLoutpage( $buf . $dbgbuf, $Title, $Meta );
exit(0);




sub pdebug
{
	my $fmt = shift( @_ );
	my $msg = sprintf( $fmt, @_ );
	return 1	if (!defined $ENV{'DEBUG'} || $ENV{'DEBUG'} ne "true");
	$dbgbuf .= sprintf( "<p><font color=\"#808080\">[D] %s</font><br>\n", $msg );
	print( STDERR "D# ", $msg );
}


sub get_backup_status
{
	my ($conf)	= @_;
	my $loadconf = "";
	my $buf;

	$sock = IO::Socket::INET->new( Proto => 'tcp', PeerAddr => $System, PeerPort => '19003' )
		or HTMLdie( "cannot connect to remote system", $Title, $Meta );

	$sock->autoflush( 1 );

	if ($conf ne "STANDARD") {
		$loadconf = "config $conf\n";
	}
	$buf = chat( $sock, "${loadconf}html\nall" );

	return $buf;
}

sub get_configs_list
{
	my $sock;
	my $buf = "";

	$sock = IO::Socket::INET->new( Proto => 'tcp', PeerAddr => $System, PeerPort => '19003' )
		or HTMLdie( "cannot connect to remote system", $Title, $Meta );

	$sock->autoflush( 1 );

	$buf	= chat( $sock, "listconfigs" );

	push( @Config, split( /[ \n]/, $buf ) );
	return 1;
}


sub get_remote_version
{
	my $sock;
	my $buf = "";

	$sock = IO::Socket::INET->new( Proto => 'tcp', PeerAddr => $System, PeerPort => '19003' )
		or HTMLdie( "cannot connect to remote system", $Title, $Meta );

	$sock->autoflush( 1 );

	$buf	= chat( $sock, "version" );

	return $buf;
}

sub chat
{
	my ($sock, $txt) = @_;
	my $buf	= "";
	my $read;
	my $result;

	pdebug( "chat(): send '%s'\n", $txt );
	$sock->print( "$txt\n" );

	while (1) {
		$read	= $sock->sysread( $result, 65565 );
		if (!defined $read) {
			pdebug( "chat(): can't read: %s\n", $! );
			#HTMLdie( "error reading from remote system: $!", $Title, $Meta );
			last;
		}
		if (!$read) {
			pdebug( "chat(): got 0 bytes\n", "" );
			last;
		}
		pdebug( "chat(), got %5d bytes '%s'\n", $read, $result );
		$buf	.= $result;
	}

	return $buf;
}
