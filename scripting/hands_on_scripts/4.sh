#!/bin/sh
# count the number of sequences in a fasta file

# - Add variable
# - Add argument for file name
# - Sanity checks

# The file to examine is given as the first argument
if [ -z ${1} ]; then
  echo "ERROR: give the name of a file as an argument"
  exit 1
fi
FILE=${1}

if [ ! -f ${FILE} ];then
  echo "ERROR: The file ${FILE} does not exist"
  exit 1
fi

echo "The number of sequences in ${FILE}"
grep -c ">" ${FILE}
