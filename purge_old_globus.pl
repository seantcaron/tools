#!/usr/bin/perl

#
# Identify and purge all old Globus Connect Server v4 packages
#

$command = "apt-get -y purge ";

open(INFILE, '-|', 'dpkg --get-selections | grep globus') or die $!;

while (<INFILE>) {
    $line = $_;
    chomp $line;

    ($package, $status) = split(" ", $line);

    open(INFILE2, '-|', "dpkg -s $package | grep Version") or die $!;

    $line2 = <INFILE2>;
    ($field, $content) = split(" ", $line2);

    if ($content =~ m/4.0.63/gi) {
        $command = $command . $package . " ";
    }

    close(INFILE2);
}

system($command) ;

system("apt -y autoremove");

close(INFILE);
