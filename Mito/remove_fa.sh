#!/bin/sh
###########################################
#Mitochondiral contig removal             #
#Author:Zhou Wu                           #
#Date:2022-Apr                            #
###########################################
# Grid Engine options
#$ -N mito
#$ -cwd
#$ -l h_vmem=8G
#$ -M zwu33@ed.ac.uk
#$ -m baes
#$ -P roslin_smith_grp
#'$ -pe sharedmem 8

# If you plan to load any software modules, then you must first initialise the modules framework.
. /etc/profile.d/modules.sh
# Choose the staging environment
#export OMP_NUM_THREADS=$NSLOTS


#Mito mapping
#module load roslin/samtools/1.10
LALOfasta=/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/RNA_LALO/mhindle/LALO_RNASeq_newgenome/LALO_new_fasta/LALO.fasta
date
Rm_scaffold=mito_out2.paf.sort.query.scaffold.header
#this command becauses format is shifted
#awk '{ if ((NR>1)&&($0~/^>/)) { printf("\n%s", $0); } else if (NR==1) { printf("%s", $0); } else { printf("\t%s", $0); } }' ${LALOfasta} | grep -Ff ${Rm_scaffold} -  > ${LALOfasta}_rm_MT.fa
MT_seq=${LALOfasta}_MT_like.fa
grep -v -Ff ${MT_seq} ${LALOfasta}>${LALOfasta}_rm_MT.fa
