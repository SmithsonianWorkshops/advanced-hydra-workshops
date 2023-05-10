#!/bin/sh
# count the number of sequences in a fasta file

# - Add variable
# - Add argument for file name
# - Sanity checks
# 4. Change to calculating number of sequences for every file in a directory

# The directory to examine is given as the first argument
if [ -z ${1} ]; then
  echo "ERROR: give the name of a directory as an argument"
  exit 1
fi
DIR=${1}

if [ ! -d ${DIR} ];then
  echo "ERROR: The directory ${DIR} does not exist"
  exit 1
fi

echo "The number of sequences in each file in ${DIR}"
for FILE in ${DIR}/*.fasta; do
  echo ${FILE}
  grep -c ">" ${FILE}
done
