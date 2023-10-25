#!/usr/bin/perl

#
# Insert this in cron to send an email report of node trouble for Slurm workers
#
# Run once daily at midnight by inserting the following into crontab for root:
#  0 0 * * * /root/cron/backup_gitlab.sh
#
#

use Sys::Hostname;
use Net::SMTP;

my @drain_nodes;
my @down_nodes;

# Get hostname
my $fqdn = hostname . ".sph.umich.edu";

# Recipient of the reports
my $recipient = "fusion-cron\@umich.edu";

# Get current date
($day, $month, $date, $time, $year) = split(" ", localtime());
my $datestring = $date . " " . $month . " " . $year;

# Use sinfo to get a list of nodes in DRAIN and DOWN states
open(INFILE, '-|', '/usr/cluster/bin/sinfo --noheader -N -t DRAIN,DOWN') or die $!;

# Loop over each line returned by sinfo
while (<INFILE>) {
    $line = $_;
    chomp $line;

    ($node, $count, $partition, $state) = split(" ", $line);

    # If the node is down, add it to the list of nodes that are down
    if (grep(/^down/, $state)) {
        # Only add it to the list if it is not there already
        if (!grep(/^$node$/, @down_nodes)) {
            push(@down_nodes, $node);
        }
    }

    # If the node is drained, add it to the list of nodes that are drained
    if (grep(/^drain/, $state)) {
        # Only add it to the list if it is not there already
        if (!grep(/^$node$/, @drain_nodes)) {
            push(@drain_nodes, $node);
        }
    }
}

# Send the report email
$smtp = Net::SMTP->new("localhost");

$smtp->mail("do-not-reply\@" . $fqdn);
$smtp->recipient($recipient);

$smtp->data();
$smtp->datasend("From: do-not-reply\@" . $fqdn . "\n");
$smtp->datasend("To: " . $recipient . "\n");
$smtp->datasend("Subject: Slurm node trouble report for " . $datestring . "\n");
$smtp->datasend("\n");
$smtp->datasend("*** Slurm node trouble report for " . $datestring . " ***\n\n");
$smtp->datasend("*** Nodes in DOWN state ***\n\n");

foreach $n (@down_nodes) {
    $smtp->datasend($n . "\n");
}

$smtp->datasend("\n*** Nodes in DRAIN state ***\n\n");

foreach $o (@drain_nodes) {
    $smtp->datasend($o . "\n");
}

$smtp->dataend();
$smtp->quit;

close(INFILE);
