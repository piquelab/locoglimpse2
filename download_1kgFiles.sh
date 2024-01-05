
mkdir 1kg
cd 1kg

## mirror ./ 
lftp http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20201028_3202_phased/

## check md5 
cat phased-manifest_July2021.tsv | awk '{print $3"\t"$1}' > md5sum.txt
md5sum -c md5sum.txt
