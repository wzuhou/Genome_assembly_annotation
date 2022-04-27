# Genome_assembly_annotation

Authors: wu090& liu194

Major Update: *20220322*

## :bar_chart: Assessment

### Genome_statistic

### RepeatMask

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

## :triangular_ruler: Dot-plot Comparative genome

`make_dot_nucmur.sh` and `mummerCoordsDotPlotly.R`

## :trumpet: Genome annotation pipeline


