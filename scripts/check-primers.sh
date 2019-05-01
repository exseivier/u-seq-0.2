#!/usr/bin/env bash

PRIMERS_SUMMARY=$1
FASTA_DATABASE=$2
MIN_RANGE=$3
MAX_RANGE=$4

while read -r LINE;
do
	LEFT_PRIMER=$(cut -f5 $LINE)
	RIGHT_PRIMER=$(cut -f6 $LINE)
	echo "Checking $LEFT_PRIMER and $RIGHT_PRIMER"
	while read -r FASTA_FILE;
	do
		# // CREATE PRIMER3 INPUT FILE p3
		# // RUN primer3_core with p3 input file
		# // PROCESS primer3_core OUTPUT
		# // APPEND RESULTS TO A FILE

	done < $FASTA_DATABASE

done < $PRIMERS_SUMMARY
