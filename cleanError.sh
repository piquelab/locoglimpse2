 grep Error GLIMPSE_ligate/*_ligated.bcf.err | cut -d: -f1 | sed 's/.err/.slurm/' | xargs rm
grep Error GLIMPSE_ligate/*_ligated.bcf.err | cut -d: -f1 | xargs rm
