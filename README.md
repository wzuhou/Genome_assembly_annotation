# Genome_assembly_annotation

Authors: wu090& liu194

Major Update: *20220322*

## :bar_chart: Assessment

### Genome_statistic

N50, N90 Calculation

### RepeatMask

```bash
RepeatModeler -database test -engine ncbi -pa 8
#export BLASTDB_LMDB_MAP_SIZE=100000000 #If needed
RepeatMasker test.fa -lib ./test-families.fa -xsmall -s -gff -pa 8
```

## :joy_cat: Kmer
`Kmer_jellyfish.sh` Using jellyfish to calculate the Kmer

## :scissors: Purge_dups

### Purge_post

Ater Purge_dups, I used my python code to select those regions at the end of the begining of a scaffold. 
See **Purge_post/**  

`Parse_purge_dups_opt.py`, `test.bed`, `test.chr_size`, and `test.out`

```bash
python3 Parse_purge_dups.py -i test.bed -s test.chr_size -o test.out
```

## :curly_loop: Mitochondrial DNA

`run_mito_mapp.sh` and `remove_fa.sh`

## :pushpin: Busco

`BUSCO.sh`

## :triangular_ruler: Dot-plot Comparative genome

`make_dot_nucmur.sh` and `mummerCoordsDotPlotly.R` (adopted from tpoorten/dotPlotly )

## :trumpet: Genome annotation pipeline

## :eyes: Scripts to create figures in paper
`Fig1_circos.R`, `Fig2_dot.R`, `Fig3_BUSCO.R`, `Fig4_chr_features.R`



