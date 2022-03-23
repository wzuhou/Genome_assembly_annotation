rule bedtools:
    threads: workflow.cores
    input:
        assembly_fasta = GENOME,
        rm_gff = rules.repeatmasker.output.repeatmasker_gff
    output:
        softmasked_fasta = f"{OUTDIR}/bedtools/{PREFIX}_softmasked.fasta"
    params:
        bedtools_dir = directory(f"{OUTDIR}/bedtools")
    shell:
        """
        bedtools maskfasta -soft \
        -fi {input.assembly_fasta} \
        -bed {input.rm_gff} \
        -fo {output.softmasked_fasta}
        """
