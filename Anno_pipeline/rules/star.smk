rule star_index:
    input:
        softmasked_fasta = GENOME,
    threads: 
        workflow.cores
    output:
        star_index = f"{OUTDIR}/star/Genome"
    params:
        star_dir = directory(f"{OUTDIR}/star"),
    shell:
        """
        STAR \
        --runMode genomeGenerate \
        --genomeDir {params.star_dir} \
        --genomeFastaFiles {input.softmasked_fasta} \
        --runThreadN {threads}
        """
        
rule star_align:
    input:
        assembly_index = rules.star_index.output.star_index,
        rna_forward_read = FORWARD_READ,
        rna_reverse_read = REVERSE_READ,
    threads: 
        workflow.cores
    output:
        sorted_alignment = f"{OUTDIR}/star/{PREFIX}_sorted_rna_alignment.bam"
    params:
        star_dir = directory(f"{OUTDIR}/star"),
        alignment_bam_raw = f"{OUTDIR}/star/Aligned.sortedByCoord.out.bam"
    shell:
        """
        cd {params.star_dir}
        
        STAR \
        --genomeDir {params.star_dir} \
        --readFilesCommand gunzip -c \
        --readFilesIn {input.rna_forward_read} {input.rna_reverse_read} \
        --outSAMtype BAM SortedByCoordinate
        --runThreadN {threads}

        mv {params.alignment_bam_raw} {output.sorted_alignment}
        """

SORTED_BAM = rules.star_align.output.sorted_alignment
