## If usign bam output

##mkdir -p bam
##cd bam; find ../../hp8265_ATAC_output/ATAC_data/ -name '*.recal.bam'  -print0 | parallel -0 'ln -s {}'

##file=GxPA14_04_S28.bam
folder=bamorig
outfolder=bam


for file in $folder/*.bam; do 
    bam=${file##$folder/}
    sample=${bam%%.bam}
    if [ ! -f "$outfolder/slurm.${sample}.out" ]; then 
	echo $sample $file
	sbatch -q secondary -n 3 -N 1-1 --mem=20G -t 2000 -J b2b_$sample -o $outfolder/slurm.$sample.out <<EOF
#!/bin/bash
module load samtools;
samtools view -h bamorig/${bam} |\
    sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2'|\
    awk -F ' ' '{ if (/^[^@]/) {$7=($7=="=" || $7=="*"?$7:sprintf("chr%s",$7))} print}' |\
    tr " " "\t" |\
    samtools view -bS - -o ${outfolder}/${bam}
    samtools index ${outfolder}/${bam}
EOF
    else 
	echo Skip ${sample}
    fi
done

