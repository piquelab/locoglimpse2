
mkdir -p fastq

##cp /wsu/home/groups/piquelab/OurData/genewiz/30-887274028/00_fastq/*.fastq.gz ./fastq/
##cp /tier2/home/groups/pique20/old.piquelab/OurData/genewiz/*/00_fastq/AL* ./fastq/

##cd fastq; 
##find /wsu/home/groups/piquelab/OurData/genewiz/ -name 'LP*R[1-2]*.fastq.gz' -print0 | parallel -0 'ln -s {}'
##rename _S1_L001_R _R *.fastq.gz

## ls /wsu/home/fe/fe01/fe0105/piquelab/OurData/genewiz/30-1141782934/00_fastq/*_R1_*fastq.gz | sed 's/_R1_.*//' > aloft2b1.ids.txt

## grep -w -f <( cut -f1 /rs/rs_grp_scaloft/scALOFT_2024/covariates/ALOFT_dbgapID_ParticipantID_key_n99ALOFT2_added_03-20-2025.txt) aloft2b1.v2.ids.txt -v
## grep -w -f aloft2b1.v2.ids.txt  /rs/rs_grp_scaloft/scALOFT_2024/covariates/ALOFT_dbgapID_ParticipantID_key_n99ALOFT2_added_03-20-2025.txt > aloft2v1.v2.ids.match.txt
## grep -w -f aloft2b1.v2.ids.txt  /rs/rs_grp_scaloft/scALOFT_2024/covariates/ALOFT_dbgapID_ParticipantID_key_n99ALOFT2_added_03-20-2025.txt | sed 's/.*://' > aloft2b1.v2.ids.match.txt

##keyfile=/rs/rs_grp_scaloft/scALOFT_2024/covariates/ALOFT_dbgapID_ParticipantID_key_n103ALOFT2_added_03-21-2025.txt
##grep -w -f aloft2b1.v2.ids.txt ${keyfile} | grep -v -w -f aloft2b1.v2.ids.match.txt | sed 's/.*://' > aloft2b1.v2.ids.match.v2.txt 

##exit 

folder1=/wsu/home/fe/fe01/fe0105/piquelab/OurData/genewiz/30-1141782934/00_fastq/
folder2=./fastq2/
cat aloft2b1.v2.ids.match.v2.txt | while read f1 f2; do 
   cp ${folder1}/${f1}_R1_001.fastq.gz ${folder2}/${f2}_R1_001.fastq.gz; 
   cp ${folder1}/${f1}_R2_001.fastq.gz ${folder2}/${f2}_R2_001.fastq.gz; 
done

exit




##folder=/nfs/rprdata/ALOFT/gencove.AloftHoldPrb.2019-03-22/bam
##folder=/rs/rs_grp_scaloft/locoglimpse2/bamfix
##folder=/nfs/rprdata/ALOFT/gencove/bam/
folder=/nfs/rprdata/ALOFT/gencove.old/bam/
outfolder=./fastq



module load samtools

for file in $folder/LP*.bam; do
    bam=${file##$folder/}
    sample=${bam%%.bam}
    if [ ! -f "$outfolder/slurm.${sample}.out" ]; then 
	echo $sample $file
	sbatch -q primary -n 3 -N 1-1 --mem=20G -t 2000 -J fq2bam_$sample -o $outfolder/slurm.$sample.out  --wrap "
module load samtools;
samtools sort -n ${file} -o $TMPDIR/${bam}
samtools fastq -1 ${outfolder}/${sample}_R1_001.fastq.gz -2 ${outfolder}/${sample}_R2_001.fastq.gz -0 /dev/null -s /dev/null -n $TMPDIR/${bam} --threads 3
"
    else 
	echo Skip ${sample}
    fi
done
