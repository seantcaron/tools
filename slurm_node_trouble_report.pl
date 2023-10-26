#!/usr/bin/perl

#
# Insert this in cron to send an email report of node trouble for Slurm workers
#
# Requires: libmime-lite-perl
#
# Run once daily at midnight by inserting the following into crontab for root:
#  0 0 * * * /root/cron/backup_gitlab.sh
#
#

use Sys::Hostname;
use MIME::Lite;

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

# Prepare report content
my $content = "<h2>Slurm node trouble report for " . $datestring . "</h2><p>";
$content = $content . "<h3>Nodes in DOWN state</h3><p>";

foreach $n (@down_nodes) {
    $content = $content . "<tt>" . $n . "</tt><br>";
}

$content = $content . "<p><h3>Nodes in DRAIN state</h3><p>";

foreach $o (@drain_nodes) {
    $content = $content . "<tt>" . $o . "</tt><br>";
}

# Send the report email
my $msg = MIME::Lite->new
(
Subject => "Slurm node trouble report for " . $datestring,
From    => "do-not-reply\@" . $fqdn,
To      => $recipient,
Type    => 'text/html',
Data    => $content
);

$msg->send();

close(INFILE);
