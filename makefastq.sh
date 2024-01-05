
mkdir -p fastq

##cp /wsu/home/groups/piquelab/OurData/genewiz/30-887274028/00_fastq/*.fastq.gz ./fastq/
##cp /tier2/home/groups/pique20/old.piquelab/OurData/genewiz/*/00_fastq/AL* ./fastq/

folder=/nfs/rprdata/ALOFT/gencove.AloftHoldPrb.2019-03-22/bam
##folder=/nfs/rprdata/ALOFT/gencove/bam/
outfolder=./fastq



module load samtools

for file in $folder/HO*.bam; do
    bam=${file##$folder/}
    sample=${bam%%.bam}
    if [ ! -f "$outfolder/slurm.${sample}.out" ]; then 
	echo $sample $file
	sbatch -q primary -n 3 -N 1-1 --mem=20G -t 2000 -J fq2bam_$sample -o $outfolder/slurm.$sample.out  --wrap "
module load samtools;
samtools sort -n ${file} -o $TMPDIR/${bam}
samtools fastq -1 ${outfolder}/${sample}_R1_001.fastq.gz -2 ${outfolder}/${sample}_R2_001.fastq.gz -0 /dev/null -s /dev/null -n $TMPDIR/${bam} --threads 3
"
    fi
done
