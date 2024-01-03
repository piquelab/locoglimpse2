#!/bin/bash

SAMPLE=HO-150

mkdir -p GLIMPSE_ligate/${SAMPLE}/
LST=GLIMPSE_ligate/${SAMPLE}/list.txt
ls -1v GLIMPSE_impute/${SAMPLE}/${SAMPLE}_imputed_*.vcf.gz > ${LST}
OUT2=GLIMPSE_ligate/${SAMPLE}/${SAMPLE}_ligated.bcf
GLIMPSE2_ligate --input ${LST} --output $OUT2


