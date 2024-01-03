#!/bin/bash
#SBATCH --job-name Glimpse
#SBATCH -q primary
#SBATCH -N 1-1
#SBATCH -n 16
#SBATCH --mem=50G
#SBATCH -t 10000

set -e 

module load samtools glimpse

SAMPLE=$1 ##HO-150
mkdir -p GLIMPSE_impute/${SAMPLE}/

BAM=./bam/${SAMPLE}.bam
OUT=GLIMPSE_impute/${SAMPLE}/${SAMPLE}_imputed

process_chunk() {
    LINE=$1
    CHR=$2
    IRG=$3

    REF=./reference_panel/split/1000GP.${CHR}
    REGS=$(echo ${IRG} | cut -d":" -f 2 | cut -d"-" -f1)
    REGE=$(echo ${IRG} | cut -d":" -f 2 | cut -d"-" -f2)
    GLIMPSE2_phase --bam-file ${BAM} --reference ${REF}_${CHR}_${REGS}_${REGE}.bin --output ${OUT}_${CHR}_${REGS}_${REGE}.vcf.gz
}

export -f process_chunk
export BAM
export OUT

cat chunks.allChr.txt | parallel -j $SLURM_NPROCS --colsep '\t' process_chunk {1} {2} {3}


mkdir -p GLIMPSE_ligate/
LST=GLIMPSE_ligate/${SAMPLE}_list.txt
ls -1v GLIMPSE_impute/${SAMPLE}/${SAMPLE}_imputed_*.vcf.gz > ${LST}
OUT2=GLIMPSE_ligate/${SAMPLE}_ligated.bcf
GLIMPSE2_ligate --input ${LST} --output $OUT2

echo "#Num_lines ${SAMPLE}" `bcftools $OUT2 | wc -l` 
