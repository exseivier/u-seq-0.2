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

echo "[USEQ    ][MESSAGE!] - Creating log file in the current working directory"
CURRENTWD=$(pwd)

if [ -f $CURRENTWD/useq.log ];
then
	echo "Begin" >> $CURRENTWD/useq.log
else
	echo "Begin" > $CURRENTWD/useq.log
fi

echo "PID=$THIS_PROCESS_PID" >> $CURRENTWD/useq.log
echo "[USEQ    ][MESSAGE!] - PROCESS PID: $THIS_PROCESS_PID"

###///### DEPRECATED ###///###

#echo "[USEQ    ][INTERACT] - PRESS ANY KEY TO CONTINUE OR C TO CANCEL IT"
#read -r GET_WARNED

#if [ "$GET_WARNED" == "C" || "$GET_WARNED" == "c" ];
#then
#	echo "[USEQ    ][WARNING!] - Exiting the program"
#	exit 0
#fi

# // BUILDING INDEXES FROM DATABASE GENOMES

###///### DEPRECATED ###///###

echo "[USEQ    ][MESSAGE!] - Calling build-db"
build-db $PATH_GENOMES_DB
echo "DB Path=$PATH_GENOMES_DB" >> $CURRENTWD/useq.log

# // SPLITTING GENOME INTO SMALL FRAGMENTS
echo "[USEQ    ][MESSAGE!] - Calling split-genome"
split-genome $PATH_QUERY_GENOME $SIZE $STEPS
echo "QUERY=$PATH_QUERY_GENOME" >> $CURRENTWD/useq.log
echo "WINDOW_SIZE=$SIZE" >> $CURRENTWD/useq.log
echo "STEPS=$STEPS" >> $CURRENTWD/useq.log


# THE OUTPUT FILES FROM BUILD-DB AND SPLIT-GENOME ARE HARDCODED HERE.
# NAMES OF THESE FILES ARE [] AND [] RESPECTIVELY AND THEY MUST BE IN THE
# SAME FOLDER WERE THIS SCRIPT WAS LAUNCHED.

## // GLOWING \\ BLINKING // GLOWING \\ BLINKING
#######################################################
FASTA_FILE_NAME=$(basename ${PATH_QUERY_GENOME} "/") ##	SOMETHING TO GET NOTED
#######################################################
TOTAL_SEQS=$(grep -c ">" ${PATH_QUERY_GENOME%/*}/splited-genome.${FASTA_FILE_NAME:0:15}.${SIZE}.${STEPS}.fas)
echo "TOTAL_SEQS=$TOTAL_SEQS" >> $CURRENTWD/useq.log

# // MAPPING WITH BLASTN
echo "[USEQ    ][MESSAGE!] - Calling blastn"
blastn -query ${PATH_QUERY_GENOME%/*}/splited-genome.${FASTA_FILE_NAME:0:15}.${SIZE}.${STEPS}.fas \
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

echo "COMMAND=blastn -query ${PATH_QUERY_GENOME%/*}/splited-genome.${FASTA_FILE_NAME:0:15}.${SIZE}.${STEPS}.fas \
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
	-gapextend $GEXT" >> $CURRENTWD/useq.log

# // PREPARING GIDS TABLE
echo "[USEQ    ][MESSAGE!] - Extracting gene ids from blast results"
cut -f1 ${PATH_QUERY_GENOME%.*}.blast | sort | uniq > ${PATH_QUERY_GENOME%/*}/gids.txt

# // SELECTING UNMAPPED SEQUENCES
echo "[USEQ    ][MESSAGE!] - Calling select-numapped."
echo "[USEQ    ][MESSAGE!] - Selecting unmapped sequences from splited-genome.${FASTA_FILE_NAME:0:15}.${SIZE}.${STEPS}.fas."
select-unmapped ${PATH_QUERY_GENOME%/*}/splited-genome.${FASTA_FILE_NAME:0:15}.${SIZE}.${STEPS}.fas \
		${PATH_QUERY_GENOME%/*}/gids.txt \
		$THIS_PROCESS_PID

UNMAPPED_SEQS=$(grep -c ">" $CURRENTWD/unmapped.$THIS_PROCESS_PID.fas)
echo "UNMAPPED_SEQS=$UNMAPPED_SEQS" >> $CURRENTWD/useq.log

# MAPPING UNMAPPED REDAS TO REFERENCE GENOME.
echo "[USEQ    ][MESSAGE!] - Calling bowtie armory."
echo "[USEQ    ][MESSAGE!] - Mapping unmapped reads to reference genome."
bowtie2-build -f $PATH_QUERY_GENOME $PATH_QUERY_GENOME
bowtie2 -x ${PATH_QUERY_GENOME} -fU unmapped.${THIS_PROCESS_PID}.fas -S unique.${THIS_PROCESS_PID}.sam


#	[TESTING] -  [OK]

echo "[USEQ    ][MESSAGE!] - Calling Samtools."
echo "[USEQ    ][MESSAGE!] - SAM <==> sorted BAM."
samtools view -bS -T ${PATH_QUERY_GENOME} -o unique.${THIS_PROCESS_PID}.bam unique.${THIS_PROCESS_PID}.sam
samtools sort -O BAM -o unique.${THIS_PROCESS_PID}.sort.bam --reference ${PATH_QUERY_GENOME} unique.${THIS_PROCESS_PID}.bam
samtools index unique.${THIS_PROCESS_PID}.sort.bam unique.${THIS_PROCESS_PID}.sort.bai

echo "[USEQ    ][MESSAGE!] - Calling cufflinks armory."
echo "[USEQ    ][MESSAGE!] - Assembling unique reads."
[ -d "cuff_out.${THIS_PROCESS_PID}" ] || mkdir cuff_out.${THIS_PROCESS_PID}
cufflinks -o cuff_out.${THIS_PROCESS_PID} unique.${THIS_PROCESS_PID}.sort.bam

echo "[USEQ    ][MESSAGE!] - Extracting exons from transcripts.gtf"

gffread cuff_out.${THIS_PROCESS_PID}/transcripts.gtf -w cuff_out.${THIS_PROCESS_PID}/exons.fa -g $PATH_QUERY_GENOME

echo "[USEQ    ][MESSAGE!] - Performing statistics"
stats cuff_out.${THIS_PROCESS_PID}/exons.fa > cuff_out.${THIS_PROCESS_PID}/useq.stats.txt
cat cuff_out.${THIS_PROCESS_PID}/useq.stats.txt
echo "End" >> $CURRENTWD/useq.log
