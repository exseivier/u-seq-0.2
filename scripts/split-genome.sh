#!/usr/bin/env bash

PATH_QUERY_GENOME=$1
SIZE=$2
STEPS=$3

if [ ! -f $(dirname ${PATH_QUERY_GENOME})/splited-genome.fas ];
then
	echo -e "[SPLIT-GENOME][MESSAGE!] - Splited query genome was not found!"
	echo -e "[SPLIT-GENOME][MESSAGE!] - Formating query genome sequence!"
	format-seq $PATH_QUERY_GENOME
	echo -e "[SPLIT-GENOME][MESSAGE!] - Building splited query genome!"
	split ${PATH_QUERY_GENOME}.fmt $SIZE $STEPS
else
	echo "[SPLIT-GENOME][MESSAGE!] - A splited query genome file was found"
	echo "[SPLIT-GENOME][MESSAGE!] - $(dirname ${PATH_QUERY_GENOME})/splited-genome.fas"
fi
