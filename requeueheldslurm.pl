#!/usr/bin/perl

# Reqeue SLURM jobs that are held in requeued state

# Prep input with:
#  squeue | grep requeued > slurmjobs

open(INFILE, "<slurmjobs");

print "#!/bin/bash\n";

while (<INFILE>) {
    $line = $_;
    chomp $line;

    ($jobid, $partition, $name, $user, $state, $time, $nodes, $nodelist) = split(" ", $line);

    print "echo Releasing job " . $jobid . "\n";
    print "/usr/cluster/bin/scontrol release " . $jobid . "\n";
    print "sleep 1\n";
}

close(INFILE);

