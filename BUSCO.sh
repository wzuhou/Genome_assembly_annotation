#!/bin/sh

# Grid Engine options
#$ -N busco
#$ -cwd
#$ -l h_vmem=8G
#$ -l h_rt=03:30:00
#$ -m baes
#$ -pe sharedmem 16

# If you plan to load any software modules, then you must first initialise the modules framework.
. /etc/profile.d/modules.sh
# Choose the staging environment
export OMP_NUM_THREADS=$NSLOTS

# Then, you must load the modules themselves
module load anaconda
source activate busco

#################
######GWCS#######
#################
fa=$1 #genome.fa
AVal=$2 #your prefix
#aves
busco -i ${fa} -o ${AVal}_aves_busco --out_path ./busco -m genome -l aves_odb10 -c 16 -f
#vertebrate
busco -i ${fa} -o  ${AVal}_vertebrata_busco --out_path ./busco -m genome -l vertebrata_odb10 -c 16 -f
#passeriformes
busco -i ${fa} -o  ${AVal}_passeri_busco --out_path ./busco -m genome -l passeriformes_odb10 -c 16 -f


#################
######trans######
#################
fa=$1 #cds.fa
AVal=$2 #your prefix
#aves
busco -i ${fa} -o ${AVal}_aves_busco --out_path ./Busco_out_trans -m transcriptome -l aves_odb10 -c 8 -f
#vertebrate
busco -i ${fa} -o  ${AVal}_vertebrata_busco --out_path ./Busco_out_trans -m transcriptome -l vertebrata_odb10 -c 8 -f
#passeriformes
busco -i ${fa} -o  ${AVal}_passeri_busco --out_path ./Busco_out_trans -m transcriptome -l passeriformes_odb10 -c 8 -f
