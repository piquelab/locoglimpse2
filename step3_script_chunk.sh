#!/bin/bash


mkdir -p chunks

for CHR in {1..22} 
do 
    MAP=./maps/genetic_maps.b38/chr${CHR}.b38.gmap.gz
    GLIMPSE2_chunk --input reference_panel/1000GP.chr${CHR}.sites.vcf.gz --sequential --region  chr${CHR} --output chunks/chunks.chr${CHR}.txt --map ${MAP}
done
