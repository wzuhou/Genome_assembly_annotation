#!/bin/sh
###Dot-plot Comparative genome
###Use the smaller genome as reference-input1

# Grid Engine options
#$ -N Nucmer
#$ -cwd
#$ -l h_vmem=64G 
#$ -pe sharedmem 8

# Choose the staging environment
export OMP_NUM_THREADS=$NSLOTS

#Compare with zebra finch
input2=Mask_LALO.fasta_rm_MT.fa
input1=Taeniopygia_guttata.bTaeGut1_v1.p.dna_sm.toplevel.fa

nucmer  ${input1} ${input2}  -p fixed_ZF -l 80 -c 100
delta-filter  -i 30 -m fixed_ZF.delta > fixed_ZF_i30_m.filter
show-coords -c -I 30 -q fixed_ZF_i30_m.filter > fixed_ZF_i30_m.filter.coords
input=fixed_ZF_i30_m.filter.coords
mummerCoordsDotPlotly.R -i ${input} -o ${input}.plot -m 1000 -q 100000 -k 10 -s -t -l -p 15 &>${input}.plot.log

######Use the smaller genome as reference-input1
#compare with chicken
input1=Gallus_gallus.GRCg6a.dna_rm.toplevel.fa

nucmer  ${input1} ${input2}  -p fixed_Gal6 -l 80 -c 100
delta-filter  -i 30 -m fixed_Gal6.delta > fixed_Gal6_i30_m.filter
show-coords -c -I 30 -q fixed_Gal6_i30_m.filter > fixed_Gal6_i30_m.filter.coords
input=fixed_Gal6_i30_m.filter.coords
mummerCoordsDotPlotly.R -i ${input} -o ${input}.plot -m 1000 -q 100000 -k 10 -s -t -l -p 12

#################
#Or Using mummer#
mummer -mum -b -c ${input1} ${input2} > mummer_LALO_ZF.mums
#############END#############
