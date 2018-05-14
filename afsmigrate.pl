#!/usr/bin/perl

#
# afsmigrate
#
# Written 26 jun 2008 by sean caron (scaron@umich.edu)
#
# Migrate afs volumes from afs_source -> afs_dest given a list of
# volumes produced by vos listvol with the header and footer line
# stripped out. It should only contain lines that look like this:
#
# user.scaron		536912944 RW    1120374 K On-line
# user.scaron.backup	536912946 BK	1120223 K On-line
#
# and so forth.
#
# Usage: afsmigrate.pl vollist sourcehost sourcepart desthost destpart
#
# Be sure to get it right because there is no error checking for command
# line arguments.
#

# Get the filename
$infile = shift;

# Get other command line arguments, source and destination host, source
# and destination partition

$sourcehost = shift;
$sourcepart = shift;
$desthost = shift;
$destpart = shift;

open(INFILE, $infile) or die "invalid input file name\n";

while (1) {
    # Get a line from the input file.
    do {
        $buf = getc(INFILE);

        # If getc returns null then we have hit EOF and are done
        if ($buf eq "") {
            die "\n* Run complete\n";
        }

        $line = $line . $buf;
    } while ($buf ne "\n");

    # Split the line into components based upon newline
    @temp = split(" ", $line);

    # We just want the volume name; first field
    $volname = @temp[0];

    #
    # Now that we have the volume name we deal with it in various ways
    #
    # 1. If backup volume (.backup) skip it, we recreate backup volumes
    # after the move
    #
    # 2. If readonly volume (.readonly) we need to deal with it using
    # vos addsite and vos release.
    #
    # 3. If normal volume we deal with it using vos move.
    #

    # Backup volume
    if ($volname =~ /.backup/i) {
        print "* Skipping backup volume ". $volname . "\n";
    }

    # Readonly volume
    elsif ($volname =~ /.readonly/i) {
        $volbase = substr($volname, 0, length($substr)-9);

        print "* Processing readonly volume " . $volbase . "\n";

        $command = "/usr/bin/vos remove " . $sourcehost . " " . $sourcepart . " " . $volname;
        system $command;

        $command = "/usr/bin/vos addsite " . $desthost . " " . $destpart . " " . $volbase;
        system $command;

        $command = "/usr/bin/vos release " . $volbase;
        system $command;

        $command = "/usr/bin/vos backup " . $volbase;
        system $command;
    }

    # Regular volume
    else {
        print "* Processing regular volume " . $volname . "\n";
        $command = "/usr/bin/vos move " . $volname . " " . $sourcehost . " " . $sourcepart . " " . $desthost . " " . $destpart . " -verbose";
        system $command;

        $command = "/usr/bin/vos backup " . $volname;
        system $command;
    }

    # Reset the input line buffer for the next iteration
    $line = "";

    # Give the network a rest
    sleep 4;
}

