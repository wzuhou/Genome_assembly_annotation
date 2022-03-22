rule hisat2_index:
    input:
        genome = GENOME
    output:
        index_file = f"{OUTDIR}/genome/{PREFIX}.1.ht2"
    params:
        outdir = directory(f"{OUTDIR}/hisat"),
        prefix = PREFIX
    shell:
        """
        hisat2-build {input.genome} {OUTDIR}/genome/{params.prefix}
        """

rule hisat2_align:
    input:
        genome = GENOME,
        forward_read = FORWARD_READ,
        reverse_read = REVERSE_READ,
        index = rules.hisat2_index.output,
    threads: 
        workflow.cores
    output:
        alignment = f"{OUTDIR}/hisat/{PREFIX}_rna_alignment.bam"
    params:
        outdir = directory(f"{OUTDIR}/hisat"),
        prefix = PREFIX
    shell:
        """
        hisat2 -x {OUTDIR}/genome/{params.prefix} -p {threads} -1 {input.forward_read} -2 {input.reverse_read} | samtools view -Sbh -o {output.alignment}
        """

rule hisat_sort_alignment:
    input:
       alignment = rules.hisat2_align.output.alignment
    threads: 
        workflow.cores
    output:
        sorted_alignment = f"{OUTDIR}/hisat/{PREFIX}sorted_rna_alignment.bam"
    shell:
        """
        samtools sort {input.alignment} -@ {threads} -o {output.sorted_alignment}
        """

SORTED_BAM = rules.hisat_sort_alignment.output.sorted_alignment
