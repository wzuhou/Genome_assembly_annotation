#!/bin/sh
# Grid Engine options
#$ -N busco
#$ -cwd
#$ -l h_vmem=8G
#$ -l h_rt=47:30:00
#$ -m baes
#$ -pe sharedmem 8
#$ -l rl9=true

# If you plan to load any software modules, then you must first initialise the modules framework.
. /etc/profile.d/modules.sh
# Choose the staging environment
export OMP_NUM_THREADS=$NSLOTS

# Then, you must load the modules themselves
module load mamba/1.5.8
source activate busco

# Input files
fa=test.cds.fa
AVal=test_anno

#aves
busco -i ${fa} -o ${AVal}_aves_busco --out_path ./Busco_out_trans -m transcriptome -l aves_odb10 -c 8 -f

#vertebrate
#busco -i ${fa} -o  ${AVal}_vertebrata_busco --out_path ./Busco_out_trans -m transcriptome -l vertebrata_odb10 -c 8 -f

#passeriformes
busco -i ${fa} -o  ${AVal}_passeri_busco --out_path ./Busco_out_trans -m transcriptome -l passeriformes_odb10 -c 8 -f
