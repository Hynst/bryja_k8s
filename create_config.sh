#!/bin/bash

SAMPLE_DIR=$1
RUN_ID=$2
SPECIES=$3

touch /mnt/shared/MedGen/bryja/config/$RUN_ID.tsv

for sample in `ls $SAMPLE_DIR/*.gz | grep R1`
do
        # get sample ID
        S_ID=`basename ${sample%_R1.fastq.gz}`
        #
        echo $S_ID
        # R1 and R2 fastq
        R1=`echo $sample`
        R2=`echo ${SAMPLE_DIR}/${S_ID}_R2.fastq.gz`
        #
        # create TSV config file
        R1_DIR_F=`echo $R1`
        R2_DIR_F=`echo $R2`
        echo $R1_DIR_F
        echo $R2_DIR_F
	awk -v S_ID="$S_ID" -v FC_ID="$RUN_ID" -v R1="$R1_DIR_F" -v R2="$R2_DIR_F" -v SP="$SPECIES" 'BEGIN{print S_ID "_" SP, "XX", "0", S_ID "_" SP, FC_ID, R1, R2}' \
        | sed 's/ /\t/g' >> /mnt/shared/MedGen/bryja/config/$RUN_ID.tsv
done
