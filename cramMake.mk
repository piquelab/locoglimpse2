# Define shell
SHELL:=/bin/bash

# Define directories
FASTQ_DIR := fastq
CRAM_DIR := cram

# Define reference genome for bwa and samtools
REF_GENOME := ./hg38ref/GRCh38_full_analysis_set_plus_decoy_hla.fa

# Get list of base names (without _R1_001.fastq.gz or _R2_001.fastq.gz)
FILES := $(notdir $(wildcard $(FASTQ_DIR)/*_R1_001.fastq.gz))
BASENAMES := $(patsubst %_R1_001.fastq.gz,%,$(FILES))

# Convert each basename to a target in the cram directory
CRAM_FILES := $(patsubst %, $(CRAM_DIR)/%.cram, $(BASENAMES))

# Default target
all: $(CRAM_FILES)

# Rule to create cram files
$(CRAM_DIR)/%.cram: $(FASTQ_DIR)/%_R1_001.fastq.gz $(FASTQ_DIR)/%_R2_001.fastq.gz
	@mkdir -p $(CRAM_DIR)
	# Align with bwa mem and convert to CRAM with samtools
	bwa-mem2 mem -Y -K 100000000 -t 12 $(REF_GENOME) $^ | samtools view -C -T $(REF_GENOME) -o $@ -

# Clean up
clean:
	rm -f $(CRAM_FILES)



##
##bwa mem -Y -K 100000000 -t 16 -R @RG\tID:NA12878_TTGCCTAG-ACCACTTA_HCLHLDSXX_L001\tPL:illumina\tPM:Unknown\tLB:NA12878\tDS:GRCh38\tSM:NA12878\tCN:NYGenome\tPU:HCLHLDSXX.1.TTGCCTAG /gpfs/internal/sweng/production/Resources/GRCh38_1000genomes/GRCh38_full_analysis_set_plus_decoy_hla.fa /gpfs/internal/sequence/demux/ILLUMINA_NOVASEQ/SNA00296/181118_SNA00296_0043_BHCLHLDSXX/01.2018-11-20_11.02.48/CCDG_13607_B01_GRM_WGS/NYGC/Project_CCDG_13607_B01_GRM_WGS/Sample_NA12878/NA12878_TTGCCTAG-ACCACTTA_HCLHLDSXX_L001/fastq/NA12878_TTGCCTAG-ACCACTTA_HCLHLDSXX_L001_001.R1.fastq.gz /gpfs/internal/sequence/demux/ILLUMINA_NOVASEQ/SNA00296/181118_SNA00296_0043_BHCLHLDSXX/01.2018-11-20_11.02.48/CCDG_13607_B01_GRM_WGS/NYGC/Project_CCDG_13607_B01_GRM_WGS/Sample_NA12878/NA12878_TTGCCTAG-ACCACTTA_HCLHLDSXX_L001/fastq/NA12878_TTGCCTAG-ACCACTTA_HCLHLDSXX_L001_001.R2.fastq.gz
##hg38ref/GRCh38_full_analysis_set_plus_decoy_hla.fa
