rule braker:
    input:
        braker_in_fasta = GENOME,
    threads: min(48, workflow.cores)
    output:
        braker_out_aa = f"{OUTDIR}/braker/augustus.ab_initio.aa",
        braker_out_gtf = f"{OUTDIR}/braker/augustus.ab_initio.gtf",
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
        
        export GENEMARK_PATH={params.genemark_path}
        export PROTHINT_PATH={params.prothint_path}
        
        cd {params.output_dir}
        braker.pl \
           --verbosity 4 \
           --min_contig=10000 \
           --esmode \
           --useexisting \
           --softmasking \
           --cores={threads} \
           --gff3 \
           --genome={input.braker_in_fasta} \
           --species={params.prefix} \
        """
