bcftools merge GLIMPSE_ligate/HO-*.bcf --threads 12 | bcftools view -v snps -m2 -M2 --threads 4 -Oz -o ./merge.ref.vcf.gz
bcftools index merge.ref.vcf.gz
bcftools merge GLIMPSE_ligate/HO-*.bcf --threads 4 | bcftools view -v snps -m2 -M2 -i 'INFO/MAF>0' --threads 4 -Oz -o ref.ac1.vcf.gz  
bcftools index ref.ac1.vcf.gz 
plink2 --make-king-table --vcf ref.ac1.vcf.gz
cat plink2.kin0 | awk '$6>0.1'
