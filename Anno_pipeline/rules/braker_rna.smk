rule braker:
    input:
        braker_in_fasta = GENOME,
        braker_in_bam = SORTED_BAM,
    threads: min(workflow.cores, 48)
    output:
        braker_out_aa = f"{OUTDIR}/braker/augustus.hints.aa",
        braker_out_gtf = f"{OUTDIR}/braker/augustus.hints.gtf",
        braker_out_gff = f"{OUTDIR}/braker/augustus.hints.gff3",
    params:
        prefix = PREFIX,
        genemark_path = locals.genemark_path,
        prothint_path = locals.prothint_path,
        output_dir = directory(OUTDIR)
    shell:
        """
        cd {params.genemark_path}
        ./check_install.bash
        
        cd {params.output_dir}
        
        braker.pl \
           --PROTHINT_PATH={params.prothint_path} \
           --GENEMARK_PATH={params.genemark_path} \
           --verbosity 4 \
           --min_contig=10000 \
           --softmasking \
           --useexisting \
           --cores={threads} \
           --gff3 \
           --genome={input.braker_in_fasta} \
           --species={params.prefix} \
           --bam={input.braker_in_bam} \
        """
