#!/bin/bash

mkdir -p reference_panel
##rm -f reference_panel/*

module load samtools

# Multiple processing commands piped together
##CHR=22

for CHR in {1..22} 
do 
    vcfFile="./1kg/CCDG_14151_B01_GRM_WGS_2020-08-05_chr${CHR}.filtered.shapeit2-duohmm-phased.vcf.gz"
    echo $CHR $vcfFile
    bcftools norm -m -any ${vcfFile} -Ou --threads 4 \
      | bcftools view -m 2 -M 2 -v snps --threads 4 -Ob -o reference_panel/1000GP.chr${CHR}.bcf
    bcftools index -f reference_panel/1000GP.chr${CHR}.bcf --threads 4
    
    bcftools view -G --threads 4 -Oz -o reference_panel/1000GP.chr${CHR}.sites.vcf.gz reference_panel/1000GP.chr${CHR}.bcf
    bcftools index -f reference_panel/1000GP.chr${CHR}.sites.vcf.gz --threads 4
done


