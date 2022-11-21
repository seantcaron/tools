# checksumming

Slurm batch scripts and output comparison utility for backup verification

General principle of operation is:

1. Prepare file lists in source and destination

    cd /source
    find ./ -print > /tmp/filelist
    cd /destination
    find ./ -print > /tmp/bkup_filelist
    
2. Split file list into chunks if desired to parallelize the checksumming work

    split --numeric-suffixes=1 --number=l/100 filelist filelist_
    split --numeric-suffixes=1 --number=l/100 bkup_filelist bkup_filelist_
    
3. Use a script with a simple foreach loop over each file in the list, run sha1sum with output redirected to a file accumulating checksum results. This repository includes example Slurm job scripts to perform this work but they can be modified to run locally if desired

4. Deduplicate (just in case) and check output files for strange characters

Remove duplicates in collated output files with:

    sort -u

Remove Ctrl-M characters in collated output files with:

    sed -e "s/\r//g"
    
5. Depending on how the file list was generated, update comparison script to trim file paths in the accumulated sha1sum output to normalize between source and destination

6. Run comparison script and review output report
