# Define shell
SHELL:=/bin/bash

# Define directories
BAM_DIR := bam
VCF_DIR := GLIMPSE_ligate

# Define reference genome for bwa and samtools
REF_GENOME := ./hg38ref/GRCh38_full_analysis_set_plus_decoy_hla.fa

# Get list of base names (e.g., HO-150)
FILES := $(notdir $(wildcard $(BAM_DIR)/*.bam))
BASENAMES := $(patsubst %.bam,%,$(FILES))

# Convert each basename to a target in the bam directory
VCF_FILES := $(patsubst %, $(VCF_DIR)/%_ligated.bcf, $(BASENAMES))

# Convert each basename to a target in the bam directory
SLURM_JOBS := $(patsubst %, %.slurm, $(VCF_FILES))


# Default target
help: 
	@echo make slurm

all: $(VCF_FILES)

# Target if slurm
slurm: $(SLURM_JOBS)

%.slurm:
	@sbatch --job-name=$* --output=$*.slurm --error=$*.err -n 16 -N 1-1 --mem=50G -t 10000 -q primary --wrap="$(MAKE) -f vcfImputeMake.mk $* -$(MAKEFLAGS)"

# Rule to create vcf files
$(VCF_DIR)/%_ligated.bcf: $(BAM_DIR)/%.bam
	bash step5_script_impute_parallel.sh $*

##GLIMPSE_ligate/HO-150/HO-150_ligated.bcf

# Clean up
clean:
	rm -f $(VCF_FILES)

