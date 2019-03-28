#!/usr/bin/env bash

while getopts ':-:' opt;
do
	if [ -z $opt ];
	then
		clear
		echo "Arguments are empty!"
		#usage
	fi
	case $opt in
		-)
			case $OPTARG in
				query)
					PATH_QUERY_GENOME=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - Query genome path: $PATH_QUERY_GENOME"
				;;
				db)
					PATH_GENOMES_DB=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - Genomes database path: $PATH_GENOMES_DB"
				;;
				size)
					SIZE=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - Window size: $SIZE"
				;;
				steps)
					STEPS=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - Size of the step: $STEPS"
				;;
				task)
					TASK=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - Required task: $TASK"
				;;
				qcov)
					QCOV=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - Query coverage percentage: $QCOV"
				;;
				identity)
					IDENTITY=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - Identity percentage: $IDENTITY"
				;;
				evalue)
					EVALUE=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - e-value cutoff: $EVALUE"
				;;
				gopen)
					GOPEN=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - Gap opening cost: $GOPEN"
				;;
				gext)
					GEXT=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - Gap extension cost: $GEXT"
				;;
				reward)
					REW=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - Matching reward: $REW"
				;;
				penalty)
					PEN=${!OPTIND}
					OPTIND=$(( $OPTIND + 1 ))
					echo "[USEQ    ][PARSING ARGS!] - Mismatching penalty: $PEN"
				;;
				help)
					echo "[USEQ    ][USAGE!] - useq --arguments --etc"
					exit 1
				;;
				?)
					echo "[USEQ    ][ERROR!] - Bad arguments"
					echo "[USEQ    ][USAGE!] - useq --arguments --etc"
					exit 1
				;;
			esac
		;;
	esac
done

THIS_PROCESS_PID=$RANDOM

echo "[USEQ    ][MESSAGE!] - PROCESS PID: $THIS_PROCESS_PID"


# // BUILDING INDEXES FROM DATABASE GENOMES
echo "[USEQ    ][MESSAGE!] - Calling build-db"
build-db $PATH_GENOMES_DB

# // SPLITTING GENOME INTO SMALL FRAGMENTS
echo "[USEQ    ][MESSAGE!] - Calling split-genome"
split-genome $PATH_QUERY_GENOME $SIZE $STEPS

# THE OUTPUT FILES FROM BUILD-DB AND SPLIT-GENOME ARE HARDCODED HERE.
# NAMES OF THESE FILES ARE [] AND [] RESPECTIVELY AND THEY MUST BE IN THE
# SAME FOLDER WERE THIS SCRIPT WAS LAUNCHED.

# // MAPPING WITH BLASTN
echo "[USEQ    ][MESSAGE!] - Calling blastn"
blastn -query ${PATH_QUERY_GENOME%/*}/splited-genome.fas \
	-db ${PATH_GENOMES_DB%.*}.db \
	-out ${PATH_QUERY_GENOME%.*}.blast \
	-evalue $EVALUE \
	-outfmt 6 \
	-perc_identity $IDENTITY \
	-subject_besthit \
	-max_target_seqs 2 \
	-qcov_hsp_perc $QCOV \
	-task $TASK \
	-reward $REW \
	-penalty $PEN \
	-gapopen $GOPEN \
	-gapextend $GEXT

# // PREPARING GIDS TABLE
echo "[USEQ    ][MESSAGE!] - Extracting gene ids from blast results"
cut -f1 ${PATH_QUERY_GENOME%.*}.blast | sort | uniq > ${PATH_QUERY_GENOME%/*}/gids.txt

# // SELECTING UNMAPPED SEQUENCES
echo "[USEQ    ][MESSAGE!] - Selecting unmapped sequences from splited-genome.fas"
select-unmapped ${PATH_QUERY_GENOME%/*}/splited-genome.fas \
		${PATH_QUERY_GENOME%/*}/gids.txt \
		$THIS_PROCESS_PID

# MAPPING UNMAPPED REDAS TO REFERENCE GENOME.
echo "[USEQ    ][MESSAGE!] - Mapping unmapped reads to reference genome"
bowtie2-build -f $PATH_QUERY_GENOME $PATH_QUERY_GENOME
bowtie2 -x ${PATH_QUERY_GENOME} -fU unmapped.${THIS_PROCESS_PID}.fas -S unique.${THIS_PROCESS_PID}.sam

#	[TESTING] -  [OK]

echo "[USEQ    ][MESSAGE!] - SAM <==> sorted BAM"
samtools view -bS -T ${PATH_QUERY_GENOME} -o unique.${THIS_PROCESS_PID}.bam unique.${THIS_PROCESS_PID}.sam
samtools sort -O BAM -o unique.${THIS_PROCESS_PID}.sort.bam --reference ${PATH_QUERY_GENOME} unique.${THIS_PROCESS_PID}.bam
samtools index unique.${THIS_PROCESS_PID}.sort.bam unique.${THIS_PROCESS_PID}.sort.bai

echo "[USEQ    ][MESSAGE!] - Assembling unique reads"
[ -d "cuff_out.${THIS_PROCESS_PID}" ] || mkdir cuff_out.${THIS_PROCESS_PID}
cufflinks -o cuff_out.${THIS_PROCESS_PID} unique.${THIS_PROCESS_PID}.sort.bam

echo "[USEQ    ][MESSAGE!] - Extracting exons from transcripts.gtf"

gffread cuff_out.${THIS_PROCESS_PID}/transcripts.gtf -w cuff_out.${THIS_PROCESS_PID}/exons.fa -g $PATH_QUERY_GENOME

echo "[USEQ    ][MESSAGE!] - Performing statistics"
stats cuff_out.${THIS_PROCESS_PID}/exons.fa > cuff_out.${THIS_PROCESS_PID}/useq.stats.txt
cat cuff_out.${THIS_PROCESS_PID}/useq.stats.txt
#echo "[MESSAGE!] - Calculating MFE"

#[ -d RNAfold.${THIS_PROCESS_PID} ] || mkdir RNAfold.${THIS_PROCESS_PID}
#RNAfold -i cuff_out.${THIS_PROCESS_PID}/exons.fa --noPS --noLP -d2 -p > RNAfold.${THIS_PROCESS_PID}/exons.MFE.txt

#echo "[MESSAGE!] - Selecting BEST unique regions"
#select-best-useqs RNAfold.${THIS_PROCESS_PID}/exons.MFE.txt best.useqs.txt

#echo "[MESSAGE!] - Cleaning the mess"
#rm *.ps

