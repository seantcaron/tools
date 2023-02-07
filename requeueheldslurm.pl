#!/usr/bin/perl

# Release all SLURM jobs that are held in requeued state

open(INFILE, '-|', '/usr/cluster/bin/squeue|grep requeued') or die $!;

while (<INFILE>) {
    $line = $_;
    chomp $line;

    ($jobid, $partition, $name, $user, $state, $time, $nodes, $nodelist) = split(" ", $line);

    print "Releasing job " . $jobid . "\n";
    system("/usr/cluster/bin/scontrol release " . $jobid);

    sleep(1);
}

close(INFILE);
