#!/bin/sh
# count the number of sequences in a fasta file

# - Add variable

# The file to examine
FILE=fastas/dapD_all.fasta

echo "The number of sequences in ${FILE}"
grep -c ">" ${FILE}
