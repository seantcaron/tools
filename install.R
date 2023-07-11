#
# Prep input with:
#   cd {R_library_repository}
#   ls -l | tr -s ' ' | cut -d ' ' -f 9 > R.libraries
#
# Run with:
#   Rscript install.R
#

library(readr)

offset <- 0

while (TRUE) {
    line = read_lines("R.libraries", skip = offset, n_max = 1)
    if (length(line) == 0) {
        break
    }
    install.packages(line, dependencies=TRUE)
    offset <- offset + 1
}
