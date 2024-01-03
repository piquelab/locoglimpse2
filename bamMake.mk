# Define shell
SHELL:=/bin/bash

# Define directories
FASTQ_DIR := fastq
BAM_DIR := bam

# Define reference genome for bwa and samtools
REF_GENOME := ./hg38ref/GRCh38_full_analysis_set_plus_decoy_hla.fa

# Get list of base names (without _R1_001.fastq.gz or _R2_001.fastq.gz)
FILES := $(notdir $(wildcard $(FASTQ_DIR)/*_R1_001.fastq.gz))
BASENAMES := $(patsubst %_R1_001.fastq.gz,%,$(FILES))

# Convert each basename to a target in the bam directory
BAM_FILES := $(patsubst %, $(BAM_DIR)/%.bam, $(BASENAMES))

# Convert each basename to a target in the bam directory
SLURM_JOBS := $(patsubst %, $(BAM_DIR)/%.bam.slurm, $(BASENAMES))


# Default target
help: 
	@echo make slurm

all: $(BAM_FILES)

# Target if slurm
slurm: $(SLURM_JOBS)

%.slurm:
	@sbatch --job-name=$* --output=$*.slurm --error=$*.err -n 12 -N 1-1 --mem=50G -t 10000 -q primary --wrap="$(MAKE) -f bamMake.mk $* -$(MAKEFLAGS)"

# Rule to create bam files
$(BAM_DIR)/%.bam: $(FASTQ_DIR)/%_R1_001.fastq.gz $(FASTQ_DIR)/%_R2_001.fastq.gz
	@mkdir -p $(BAM_DIR)
	# Align with bwa mem and convert to BAM with samtools
	module load bwa-mem2 samtools; \
	bwa-mem2 mem -Y -K 100000000 -t 12 $(REF_GENOME) $^ | samtools view -bS - | samtools sort -o $@
	samtools index $@
# Clean up
clean:
	rm -f $(BAM_FILES)

