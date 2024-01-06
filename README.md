## Low coverage imputation using GLIMPSE2 in the grid

This are the scripts used to use GLIMPSE2 (https://www.nature.com/articles/s41588-020-00756-0) method to impute genotypes from low coverage sequencing at the Wayne State High Performance Comuting Grid. We perviously used Gencove for both making the data and imputation, and we wanted to repeat the multiple batches using the same pipeline. We adapted the analysis steps from the GLIMPSE2 tutorial here (https://odelaneau.github.io/GLIMPSE/). The starting point are fastq files (or bam with bam2fastq converted files) and for each one we obtain a vcf file with the same reference panel and software version. The overall steps would be as follow:

1. Clone the github repo in a new folder where the analysis will be performed. 
```
git clone git@github.com:piquelab/locoglimpse2.git
```
2. Make links to all the reference files needed for aligment and imputation to already existing locations in the cluster. Alternatively, you may want to create new references from scratch (see below). The ones in the following script are based on hg38 and the latest release of the 1KG remapped on hg38. 
```
bash makeRefLinks.sh
```
3. Put all the fastq files on the `./fastq/` folder or convert them from bam to fastq. See and adapt `makefastq.sh`.  
4. Alignment of all the fastq reads with the reference using BWA-MEM2 using Slurm jobs
```
make -f bamMake.mk slurm
```
5. Imputation using 1KG panel. Using Slurm jobs. 
```
make -f bamMake.mk slurm
```
7. Merging all bcf files into one vcf.gz file. See or adapt `final_merge.sh`

## Steps to make a reference

