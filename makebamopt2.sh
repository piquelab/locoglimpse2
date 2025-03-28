## If usign bam output

mkdir -p bam
##cd bam; find ../../hp8265_ATAC_output/ATAC_data/ -name '*.recal.bam'  -print0 | parallel -0 'ln -s {}'
## /rs/rs_grp_gxp/hp8265_ATAC_output/ATAC_data_EC/GxPA9_12_S8.filtered.trimmed.bam 
##mkdir -p bamorig
## ATAC
##cd bamorig; find ../../hp8265_ATAC_output/ATAC_data_EC/ -name '*.filtered.trimmed.bam' -print0 | parallel -0 'ln -s {}'
##rename .filtered.trimmed.bam .bam *.bam
## _clean.bam 

## RNA
##mkdir -p bamorig
##cd bamorig; find /rs/rs_grp_gxp/RNAseq_analysis/CB_align_test/ -name '*_clean.bam' -print0 | parallel -0 'ln -s {}'
##rename _clean.bam  .bam *.bam
## rename FL-GG-5s-pl9-GxP GxP *.bam
## rename _S*.bam .bam *.bam
## for f in ls *_S[0-9]*.bam; do mv -v "$f" "${f/_S[0-9]*.bam/.bam}"; done

## Adds chr. 
folder=bamorig
outfolder=bam

for file in $folder/*.bam; do
    bam=${file##*/}
    sample=${bam%%.bam}
    if [ ! -f "$outfolder/slurm.${sample}.out" ]; then
        echo $sample $file
        script_file=${outfolder}/${sample}.sh
        cat > $script_file <<EOF
#!/bin/bash
module load samtools;
samtools view -h $file |\
    sed -e '/^@SQ/s/SN:/SN:chr/' -e '/^[^@]/s/\t/\tchr/2' |\
    grep -v '^@PG' |\
    awk -F ' ' '{ if (/^[^@]/) {\$7=(\$7=="=" || \$7=="*"?\$7:sprintf("chr%s",\$7))} print}' |\
    tr " " "\t" |\
    samtools view -b - -o ${outfolder}/${bam};
samtools index ${outfolder}/${bam}
EOF
        # Submit the script to sbatch
        sbatch -q primary -n 3 -N 1-1 --mem=20G -t 2000 -J b2b_$sample -o $outfolder/slurm.$sample.out $script_file
        # Optionally, remove the temporary script file after submission
##        rm $script_file
    else
        echo "Skip ${sample}"
    fi
done

