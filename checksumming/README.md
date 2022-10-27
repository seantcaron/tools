Slurm batch scripts and output comparison utility for backup verification

Input file preparation:

    split --numeric-suffixes=1 --number=l/100 filelist filelist_
    split --numeric-suffixes=1 --number=l/100 bkup_filelist bkup_filelist_

Remove duplicates in collated output files with:

    sort -u

Remove Ctrl-M characters in collated output files with:

    sed -e "s/\r//g"
