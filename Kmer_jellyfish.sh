#!/bin/bash
source activate py37

#Input fatsa
Inputfasta=<path_to_file>/LALO.fasta
jellyfish count -m 21 -s 100M ${Inputfasta} -t 4 -o lalo.jf 
jellyfish dump -c lalo.jf
jellyfish histo lalo.jf

#Input fq
Inputfq=<path_to_file>/lalo_pacbio.fastq.gz
zcat ${Inputfq} |jellyfish count -m 21 -t 4 -s 1G -C -o lalo_fq.jf /dev/fd/0
#jellyfish dump -c lalo_fq.jf >lalo_fq.jf.dump
jellyfish histo lalo_fq.jf


#Genome scope website
# http://qb.cshl.edu/genomescope/
#using the histo file: e.g. lalo_fq.jf.histo
