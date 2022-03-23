import os
if not Path(f"{OUTDIR}/isoseq").exists():
    Path(f"{OUTDIR}/isoseq").mkdir()
if "," in ISOSEQ_READ:
    cmd = "cat " + " ".join(ISOSEQ_READ.split(",")) + " > " + str(Path(f"{OUTDIR}/isoseq")) + "/all_isoseq.fq"
    print(cmd)
    os.system(cmd)
    ISOSEQ_READ = f"{OUTDIR}/isoseq/all_isoseq.fq"

rule minimap:
    input:
        genome = GENOME,
        isoseq_read = ISOSEQ_READ,
    output:
        sorted_alignment = f"{OUTDIR}/isoseq/long_reads.sorted.sam",
    threads: 
        workflow.cores
    params:
        alignment = f"{OUTDIR}/isoseq/long_reads.sam",
        outdir = directory(f"{OUTDIR}/isoseq"),
        prefix = PREFIX
    shell:
        """
        minimap2 -t {threads} -ax splice:hq {input.genome} {input.isoseq_read}  > {params.alignment}
        sort -k 3,3 -k 4,4n {params.alignment} > {output.sorted_alignment}
        """

rule cupcake:
    input:
        sorted_alignment = rules.minimap.output.sorted_alignment,
        isoseq_read = ISOSEQ_READ,
    output:
        collapsed_transcripts = f"{OUTDIR}/isoseq/cupcake.collapsed.gff"
    threads: 
        workflow.cores
    params:
        outdir = directory(f"{OUTDIR}/isoseq"),
        prefix = PREFIX
    shell:
        """
        collapse_isoforms_by_sam.py --input {input.isoseq_read} --fq  -s {input.sorted_alignment} --dun-merge-5-shorter -o {params.outdir}/cupcake
        """

rule genemarkst:
    input:
        genome = GENOME,
        collapsed_transcripts = rules.cupcake.output.collapsed_transcripts,
    output:
        gmst_out_gtf = f"{OUTDIR}/isoseq/gmst.global.gtf"
    threads: 
        workflow.cores
    params:
        gmst_path = locals.gmst_path,
        stringtie2fa_path = locals.stringtie2fa_path,
        gmst2globalCoords = locals.gmst2globalCoords,
        outdir = directory(f"{OUTDIR}/isoseq"),
        prefix = PREFIX
    shell:
        """
        export PATH=$PATH:{params.stringtie2fa_path}:{params.gmst2globalCoords}:{params.gmst_path}
        stringtie2fa.py -g {input.genome} -f {input.collapsed_transcripts} -o {params.outdir}/cupcake.fa
        gmst.pl --strand direct {params.outdir}/cupcake.fa.mrna --output {params.outdir}/gmst.out --format GFF
        gmst2globalCoords.py -t {input.collapsed_transcripts} -p {params.outdir}/gmst.out -o {output.gmst_out_gtf} -g {input.genome}
        """
