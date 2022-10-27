#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=28-00:00:00
#SBATCH --chdir=/net/dumbo/home/scaron/disk1_checksumming_work
#SBATCH --job-name=shasumbkup
#SBATCH --mail-type=ALL
#SBATCH --mail-user=scaron@umich.edu
#SBATCH --array=1-100

for file in `cat bkup_filelist_${SLURM_ARRAY_TASK_ID}` ; do
  sha1sum $file >> shasumcheckbkup_${SLURM_ARRAY_TASK_ID}
done
