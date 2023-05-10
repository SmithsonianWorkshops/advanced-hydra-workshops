#!/bin/sh
# count the number of sequences in a fasta file

# - Add variable
# - Add argument for file name

# The file to examine is given as the first argument
FILE=${1}

echo "The number of sequences in ${FILE}"
grep -c ">" ${FILE}
