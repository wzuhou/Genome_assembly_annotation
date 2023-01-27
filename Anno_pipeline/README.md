# Pipeline for genomes annotation
## Workflow

## Install, set and run
#please read INSTALL.md

## Modes

All modes are used [RepeatMasker](http://www.repeatmasker.org/RepeatModeler/) tool for repeats masking, modes are:
1) **FASTA** - [BRAKER2](https://github.com/Gaius-Augustus/BRAKER) predicts genes on genome data training only
2) **FASTA_FAA** - [BRAKER2](https://github.com/Gaius-Augustus/BRAKER) predicts genes on proteins and genome data training 
3) **FASTA_RNA** - [BRAKER2](https://github.com/Gaius-Augustus/BRAKER) predicts genes on RNA-seq and proteins data training. [HISAT2](http://daehwankimlab.github.io/hisat2/) is used to align RNA reads
4) **FASTA_RNA_FAA** - [BRAKER2](https://github.com/Gaius-Augustus/BRAKER) predicts genes on genome, RNA-seq and proteins data training. [HISAT2](http://daehwankimlab.github.io/hisat2/)  is used to align RNA reads
5) **FASTA_RNA_FAA_ISO** - TODO

After genes are predicted, run [Eggnog-mapper](https://github.com/eggnogdb/eggnog-mapper) to define functions of a genes
## Command line options 

```
-h, --help            show this help message and exit
-m {fasta,fasta_rna,fasta_faa,fasta_rna_faa}, --mode {fasta,fasta_rna,fasta_faa,fasta_rna_faa}
                     mode to use [default = fasta]
-a ASSEMBLY, --assembly ASSEMBLY
                     path to asssembly fasta file
-s1 FORWARD_RNA_READ, --forward_rna_read FORWARD_RNA_READ
                     path to forward rna-seq read, R1_1.fq,R2_1.fq,R3_1.fq...
-s2 REVERSE_RNA_READ, --reverse_rna_read REVERSE_RNA_READ
                     path to reverse rna-seq read, R1_2.fq,R2_2.fq,R3_2.fq...
-iso ISOSEQ_READ, --isoseq_read ISOSEQ_READ
                     path to isoseq read, isoseq_1.fq,isoseq_2.fq...
-f FAA, --faa FAA     path to protein fasta file (.faa), required for fasta_faa and fasta_rna_faa modes
-o OUTDIR, --outdir OUTDIR
                     output directory [default is folder of your assembly file]
-t THREADS, --threads THREADS
                     number of threads [default == 8]
-d, --debug           debug mode
```

## Test dataset
```bash
wget http://topaz.gatech.edu/GeneMark/Braker/RNAseq.bam  
wget https://raw.githubusercontent.com/Gaius-Augustus/BRAKER/master/example/genome.fa   
wget https://raw.githubusercontent.com/Gaius-Augustus/BRAKER/master/example/proteins.fa  
samtools sort -n -o RNAseq.sorted.bam RNAseq.bam  
bedtools bamtofastq -i RNAseq.sorted.bam -fq R1.fq -fq2 R2.fq  
```

```bash
python3 Anno_pipeline.V1.py \  
-m fasta_rna_faa \  
    -a genome.fa \  
    -s1 R1.fq \  
    -s2 R2.fq \  
    -iso R1.fq,R2.fq \  
    -f proteins.fa \  
    -o test_pipeline \  
    -t 2 
```
