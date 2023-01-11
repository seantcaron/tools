#!/usr/bin/perl

# This takes a Puppet manifest full of package declarations and
#  attempts to cross-check them with the repository on the Ubuntu
#  site to determine whether or not they are in the specified
#  distribution.

# Install on Ubuntu with: apt-get install libhttp-message-perl
require HTTP::Request;
require HTTP::Response;

# Install on ubuntu with: apt-get install libtest-lwp-useragent-perl
require LWP::UserAgent;

$ARGC = scalar @ARGV;

if ( $ARGC != 2 ) {
    print "Usage: pkgsinrepo.pl [input_manifest] [output_log]\n";
    exit 1;
}

$input_manifest = "<".$ARGV[0];
$output_log = ">".$ARGV[1];

open(OUTFILE, $output_log) or die "Error opening output log file!\n";
open(INFILE, $input_manifest) or die "Error opening input manifest!\n";

while (<INFILE>) {
    $line = $_;
    chomp $line;
        
    if ( ($line =~ m/package/gi) && !($line =~ /^\s*#/) ) {
        print "Processing: " . $line . "\n";

        ($package, $rightbrace, $pkgname) = split(" ", $line);

        # Remove trailing quotation mark and colon
        chop $pkgname;
        chop $pkgname;

        # Remove leading quotation mark
        $pkgname = substr($pkgname, 1);

        # At this point, we should have a raw package name which we'll convert to
        #  a URI
	$uri = "http://packages.ubuntu.com/focal/" . $pkgname;

        # Now we assemble that into a request and go fetch it
        $req = HTTP::Request->new(GET => $uri);
        $ua = LWP::UserAgent->new;
        $resp = $ua->request($req);

        $resp_text = $resp->as_string;

        if ( ($resp_text =~ m/No such package/gi) || ($resp_text =~ m/Package not available in this suite/gi) ) {
            print OUTFILE "No such package " . $pkgname . "\n";
	}

	elsif ( $resp_text =~ m/This is a virtual package/gi ) {
	    print OUTFILE "NOTE: Package " . $pkgname . " is a virtual package\n";
        }

	else {
	    print OUTFILE "Found package " . $pkgname . "\n";
        }
    }
}

close(INFILE);
close(OUTFILE);

