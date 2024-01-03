#!/bin/bash

mkdir -p reference_panel/split

#VCF=NA12878_1x_vcf/NA12878.chr22.1x.vcf.gz
##BAM=NA12878_1x_bam/NA12878.bam


cat chunks.allChr.txt | \
while read LINE CHR IRG ORG; 
do
    REF=./reference_panel/1000GP.${CHR}.bcf
    MAP=./maps/genetic_maps.b38/${CHR}.b38.gmap.gz

    GLIMPSE2_split_reference --reference ${REF} --map ${MAP} --input-region ${IRG} --output-region ${ORG} --output reference_panel/split/1000GP.${CHR}
done 


##	printf -v ID "%02d" $(echo $LINE | cut -d" " -f1)
##	IRG=$(echo $LINE | cut -d" " -f3)
##	ORG=$(echo $LINE | cut -d" " -f4)
##	#OUT=GLIMPSE_impute/NA12878.chr22.imputed.${ID}.bcf
