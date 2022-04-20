rule rmbuildb:
    threads: 
        workflow.cores
    input:
        assembly_fasta = GENOME
    output:
        database_translation = f"{OUTDIR}/genome/{PREFIX}.translation"
    params:
        db_prefix = f"{OUTDIR}/genome/{PREFIX}"
    shell:
        """
        BuildDatabase -name {params.db_prefix} {input.assembly_fasta}
        """


rule repeatmodeler:
    threads:
        workflow.cores
    input:
        database = rules.rmbuildb.output.database_translation
    output:
        rm_families = f"{OUTDIR}/genome/{PREFIX}-families.fa"
    params:
        database_prefix = f"{OUTDIR}/genome/{PREFIX}",
        ninja_dir = locals.ninja_path
    shell:
        """
        RepeatModeler \
        -ninja_dir {params.ninja_dir} \
        -pa {threads} \
        -LTRStruct \
        -database {params.database_prefix}
        """


rule repeatmasker:
    threads:
        workflow.cores
    input:
        assembly = GENOME,
        rm_families = rules.repeatmodeler.output.rm_families
    output:
        repeatmasker_gff = f"{OUTDIR}/repeatmasker/{PREFIX}.fasta.out.gff"
    params:
        rm_dir = directory(f"{OUTDIR}/repeatmasker/")
    shell:
        """
        RepeatMasker \
        -pa {threads} \
        -lib {input.rm_families} \
        -xsmall -gff -dir {params.rm_dir} \
        {input.assembly}
        """
