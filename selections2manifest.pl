#!/usr/bin/perl

# This takes a list of debian package selections generated with:
#   dpkg --get-selections > my-selections
# and turns them into a manifest file suitable for use with Puppet.

# remember to remove any deinstall lines from the input manifest!

# Usage: selections2manifest [classname] [input_manifest] [output_manifest]

$ARGC = scalar @ARGV;

if ( $ARGC != 3 ) {
    print "Usage: selections2manifest [classname] [input_manifest] [output_manifest]\n";
    exit 1;
}

$class_name = $ARGV[0];
$input_manifest = "<".$ARGV[1];
$output_manifest = ">".$ARGV[2];

open(OUTFILE, $output_manifest) or die "Error opening output manifest file!\n";

open(INFILE, $input_manifest) or die "Error opening input manifest file!\n";

print OUTFILE "class " . $class_name . " {\n";

while (<INFILE>) {
    $line = $_;
    chomp $line;

    ($package, $action) = split(" ", $line);

    # Only include packages with state install, not hold, deinstall or purge
    if ( $action eq "install") {
        print OUTFILE "    package { " . "\'" . $package . "\':\n";
        print OUTFILE "        ensure => present\n";
        print OUTFILE "    }\n\n";
    }
}

close(INFILE);

print OUTFILE "}\n\n";

close(OUTFILE);

