#!/bin/bash
# cutadapt.sh

# This script uses cutadapt to trim 3' and 5' adapters used for generating ENCODE miRNA-seq data.
# Requires python2.7


## ----------------- sequencing adapter information ------------------ 
#  The 3' adapter sequence:
THREE_PRIME_AD_SEQ="ACGGGCTAATATTTATCGGTGGAGCATCACGATCTCGTAT"

# A cocktail of 5' adapters used to generate miRNA-seq samples
FIVE_PRIME_AD1_SEQ="^CAGTCG"
FIVE_PRIME_AD2_SEQ="^TGACTC"
FIVE_PRIME_AD3_SEQ="^GCTAGA"
FIVE_PRIME_AD4_SEQ="^ATCGAT"
## -------------------------------------------------------------------

## ------------------------- input files -----------------------------
#  The input raw miRNA-seq reads in fastq format:
GZ=$1

# Prefix for output files:
TEMP_BASE=$2

# Destination directory:
DEST_DIR=$3
## -------------------------------------------------------------------

## ------------------------- output files ----------------------------
#  Output file with trimmed reads:
TRIM_FILE=$DEST_DIR"/"$TEMP_BASE"_trim.fastq"

#  Output file with reads that failed to trim (3' step):
NO_3AD_FILE=$DEST_DIR"/"$TEMP_BASE"_NO3AD.fastq"

#  Output file with reads that failed to trim (5' step):
NO_5AD_FILE=$DEST_DIR"/"$TEMP_BASE"_NO5AD.fastq"

#  Output file with trimmed reads that are too short:
TOO_SHORT_FILE=$DEST_DIR"/"$TEMP_BASE"_SHORT_FAIL.fastq"
## -------------------------------------------------------------------

cutadapt -a $THREE_PRIME_AD_SEQ -e 0.25 --match-read-wildcards --untrimmed-output=$NO_3AD_FILE $GZ | cutadapt -e 0.34 --match-read-wildcards --no-indels -m 15 -O 6 -n 1 -g $FIVE_PRIME_AD1_SEQ -g $FIVE_PRIME_AD2_SEQ -g $FIVE_PRIME_AD3_SEQ -g $FIVE_PRIME_AD4_SEQ --untrimmed-output=$NO_5AD_FILE --too-short-output=$TOO_SHORT_FILE - > $TRIM_FILE
