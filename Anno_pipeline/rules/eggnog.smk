rule eggnog:
    input:
        proteins_file = rules.braker.output.braker_out_aa,
        gff_file = rules.braker.output.braker_out_gff
    threads:
        workflow.cores
    output:
        eggnog_out_annotation = f"{OUTDIR}/eggnog/{PREFIX}.emapper.annotations", 
        eggnog_out_orthologs = f"{OUTDIR}/eggnog/{PREFIX}.emapper.seed_orthologs",
    params:
        eggnog_db = locals.eggnog_db,
        eggnog_prefix = PREFIX,
        eggnog_dir = f"{OUTDIR}/eggnog",
    shell:
        """
        emapper.py \
          --data_dir {params.eggnog_db} \
          -i {input.proteins_file} \
          -m diamond \
          --cpu {threads} \
          --decorate_gff  {input.gff_file} \
          --output {params.eggnog_prefix} \
          --output_dir {params.eggnog_dir}
        """
