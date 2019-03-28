#!/usr/bin/env bash

BLAST_OUTPUT=$1
DB=$2
grep "^[[:digit:]]*\." $BLAST_OUTPUT | sed 's/[[:digit:]]*\. //g; s/ /_/g' > species.tmp
No_SPECIES=$(cat species.tmp | wc -l)
head -n 7 species.tmp
echo "[BATCH-DL][MESSAGE!] - $(echo $No_SPECIES - 7 | bc -l) species remains."

while read -r SPECIE;
do
	wget -nv -O- ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/${DB}/${SPECIE%?}/latest_assembly_versions/ \
	| grep "\/GC.*\/" \
	| sed 's/.*">//g; s/<.a>.*//g' > index.tmp

	while read -r INDEX;
	do
		wget ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/${DB}/${SPECIE%?}/latest_assembly_versions/${INDEX}/${INDEX}_genomic.fna.gz
	
	done < index.tmp

done < species.tmp
