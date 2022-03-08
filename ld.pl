#!/usr/bin/perl

#
# Line diff
#

$num_args = scalar @ARGV;

if ($num_args != 2) {
    print "Usage: ld.pl file1 file2\n";
    exit 1;
}

$filepath1 = "<" . $ARGV[0];
$filepath2 = "<" . $ARGV[1];

open(FILEA, $filepath1) or die "Failed opening " . $ARGV[0] .  "\n";
my(@lines_a) = <FILEA>;
close(FILEA);

open(FILEB, $filepath2) or die "Failed opening " . $ARGV[1] . "\n";
my(@lines_b) = <FILEB>;
close(FILEB);

print "Lines found in " . $ARGV[0] . " but not " . $ARGV[1] . ":\n";

foreach $line_a (@lines_a) {
    $line_found = 0;

    foreach $line_b (@lines_b) {
        if ($line_a eq $line_b) {
            $line_found = 1;
        }
    }

    if ($line_found != 1) {
        print $line_a;
    }

    $line_found = 0;
}

print "Lines found in " . $ARGV[1] . " but not " . $ARGV[0] . ":\n";

foreach $line_b (@lines_b) {
    $line_found = 0;

    foreach $line_a (@lines_a) {
        if ($line_b eq $line_a) {
            $line_found = 1;
        }
    }

    if ($line_found != 1) {
        print $line_b;
    }

    $line_found = 0;
}

exit
