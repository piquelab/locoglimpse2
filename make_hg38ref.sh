#!/bin/bash

set -e

mkdir hg38ref
cd hg38ref

wget "http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa"
module load samtools bwa-mem2
bwa-mem2 index GRCh38_full_analysis_set_plus_decoy_hla.fa 

