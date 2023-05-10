#!/bin/sh
# count the number of sequences in a fasta file
echo "The number of sequences in fastas/dapD_all.fasta"
grep -c ">" fastas/dapD_all.fasta
