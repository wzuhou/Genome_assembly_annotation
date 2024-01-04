#!/bin/bash
OUTPUT=./Output/
PREFIX=GWCS
GENOME=./GWCS.softmasked.fasta

# Transdecoder
gtf_genome_to_cdna_fasta.pl ${OUTPUT}/portcullis/psiclassGWCS_vote.gtf $GENOME > ${OUTPUT}/portcullis/psiclassGWCS_vote.fa
#1. First run the TransDecoder.LongOrfs step that identifies all long ORFs.
TransDecoder.LongOrfs -S -t psiclassGWCS_vote.fa

# Blast
#make database
makeblastdb -in uniprot_sprot.fasta -dbtype nucl -out uniprot_sprot
#Search blastp
QUERY=./Output/portcullis/psiclassGWCS_vote.fa.transdecoder_dir/longest_orfs.pep 
blastp -query $QUERY -db uniprot_sprot -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 12 > blastp_psiclassGWCS_vote.outfmt6

# Pfam 
hmmscan --cpu 12 --domtblout pfam.domtblout  ./Anno_pipeline/eggnog_db/pfam/Pfam-A.hmm  $QUERY

#2. Now, run the TransDecoder.Predict step that predicts which ORFs are likely to be coding.

TransDecoder.Predict -t psiclassGWCS_vote.fa --retain_pfam_hits pfam.domtblout --retain_blastp_hits blastp_psiclassGWCS_vote.outfmt6 --output_dir psiclassGWCS_vote.fa.transdecoder_dir

#using trandecoder Convert format, otherwise the scaffold name has extension with transcript start and end pos. The annotation gtf needs to be converted to alignment gff, which is very differemt. Tried agat or the website recommanded script, both did not work, the following is working
### another way to do this
#gtf_genome_to_cdna_fasta.pl psiclassGWCS_vote.gtf $GENOME > psiclassGWCS_vote.fa

gtf_to_alignment_gff3.pl psiclassGWCS_vote.gtf $GENOME > psiclassGWCS_vote_trans.gff3

#/env/Anno_pipeline/bin/cdna_alignment_orf_to_genome_orf.pl cdna_orfs.genes.gff3 cdna_genome.alignments.gff3 cdna.fasta [DEBUG]
cdna_alignment_orf_to_genome_orf.pl ./psiclassGWCS_vote.fa.transdecoder.gff3 ./psiclassGWCS_vote_trans.gff3 ./psiclassGWCS_vote.fa > psiclassGWCS_vote.fa.transdecoder.genome.gff3

#gff to gtf
gffread psiclassGWCS_vote.fa.transdecoder.genome.gff3 -T -o psiclassGWCS_vote.fa.transdecoder.genome.gtf # test with featurecounts

####
gtf_to_alignment_gff3.pl outAll_M_hq_fixed_renamed.gtf >outAll_M_hq_fixed_renamed_trans.gff3

cdna_alignment_orf_to_genome_orf.pl outAll_M_hq_fixed_renamed.gtf.fa.transdecoder.gff3 outAll_M_hq_fixed_renamed_trans.gff3 outAll_M_hq_fixed_renamed.gtf.fa >outAll_M_hq_fixed_renamed.gtf.fa.transdecoder.genome.gff3
