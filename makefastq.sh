
mkdir -p fastq

##cp /wsu/home/groups/piquelab/OurData/genewiz/30-887274028/00_fastq/*.fastq.gz ./fastq/


folder=/nfs/rprdata/ALOFT/gencove.AloftHoldPrb.2019-03-22/bam
outfolder=./fastq



module load samtools

for file in $folder/HO*.bam; do
    bam=${file##$folder/}
    sample=${bam%%.bam}
    echo $sample $file
    samtools fastq -1 ${outfolder}/${sample}_R1_001.fastq.gz -2 ${outfolder}/${sample}_R2_001.fastq.gz -0 /dev/null -s /dev/null -n ${file} --threads 3
done

##samtools fastq -1 HO-001_R1_001.fastq -2 HO-001_R2_001.fastq -0 /dev/null -s /dev/null -n /nfs/rprdata/ALOFT/gencove.AloftHoldPrb.2019-03-22/bam/HO-001.bam

