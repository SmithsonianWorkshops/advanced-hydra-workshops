#!/bin/sh
# 1. count the number of sequences in a fasta file
# 2. Add variable
# 3. Add argument for file name
# 4. Add sanity checks
# 5. Change to calculating number of sequences for every file in a directory
# 6. Get portions of filename to improve output

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
  FILENAME=$(basename ${FILE})
  GENENAME=$(echo ${FILENAME} | sed 's/.fasta//')
  echo "${FILENAME}, (gene: ${GENENAME})"
  grep -c ">" ${FILE}
done
