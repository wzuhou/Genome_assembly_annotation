#!/bin/sh
###########################################
#Mitochondiral DNA mapping using minimap2 #
#Author:Zhou Wu                           #
#Date:2022-Mar                            #
###########################################

# Grid Engine options
#$ -N mito
#$ -cwd
#$ -l h_vmem=8G
#$ -M zwu33@ed.ac.uk
#$ -m baes
#$ -pe sharedmem 8

# If you plan to load any software modules, then you must first initialise the modules framework.
. /etc/profile.d/modules.sh
# Choose the staging environment
export OMP_NUM_THREADS=$NSLOTS

# Then, you must load the modules themselves
module load anaconda
# Load conda env
source activate py37

#Mito mapping
module load roslin/samtools/1.10
date

LALOfasta=/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/RNA_LALO/mhindle/LALO_RNASeq_newgenome/LALO_new_fasta/LALO.fasta
ref=Gallus_gallus.GRCg6a.dna.chromosome.MT.fa
#minimap2  -t8 -x asm20 ${ref} ${LALOfasta} -o mito_out2.paf #distance between chicken and LALO is far thus asm20
ref=Mitogenome.fa.reorder.fa
minimap2  -t8 -x asm5 ${ref} ${LALOfasta} -o mito_out_self.paf

# sam extreact mapped contigs
samtools view -Sh -F 4 mito_out2.sam > mapped_mito_out2.sam
# sam flagstat
samtools flagstat mapped_mito_out2.sam >flagstat.mapped_mito_out2.sam
# sam to fa
samtools bam2fq mapped_mito_out2.sam | seqtk seq -A - > output.fa 
date
