#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#@created: 18.03.2022
#@author: Langqing Liu
#@contact: llq0325@gmail.com

import argparse
import os
import os.path
from inspect import getsourcefile
from datetime import datetime
import string
import random

def config_maker(settings, config_file):
    config = f"""
    "outdir" : "{settings["outdir"]}"
    "genome" : "{settings["assembly_fasta"]}"
    "forward_read" : "{settings["fr"]}"
    "reverse_read" : "{settings["rr"]}"
    "isoseq_read" : "{settings["iso"]}"
    "proteins" : "{settings["faa"]}"
    "mode" : "{settings["mode"]}"
    "aligner" : "{settings["aligner"]}"
    "softmasked" : "{settings["softmasked"]}"
    "threads" : "{settings["threads"]}"
    "braker_mode": "{settings["braker_mode"]}"
    "species": "{settings["species"]}"
    """

    if not os.path.exists(os.path.dirname(config_file)):
        os.mkdir(os.path.dirname(config_file))


    with open(config_file, "w") as fw:
        fw.write(config)
        print(f"CONFIG IS CREATED! {config_file}")
      

def main(settings):
    ''' Function description.
    '''
        
    if settings["debug"]:
        snake_debug = "-n --rulegraph"
    else:
        snake_debug = ""

    #Snakemake
    command = f"""
    snakemake --snakefile {settings["execution_folder"]}/workflow/snakefile \
              --configfile {settings["config_file"]} \
              --cores {settings["threads"]} \
              --use-conda {snake_debug}"""
    print(command)
    os.system(command)


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='A tool for genome annotation project.')
    parser.add_argument('-m','--mode', help="mode to use [default = fasta]", 
                        choices=["fasta", "fasta_rna", "fasta_faa", "fasta_rna_faa", "fasta_rna_faa_isoseq"], default="fasta")
    parser.add_argument('-a','--assembly', help="path to asssembly fasta file", required=True)
    parser.add_argument('-s1','--forward_rna_read', help="path to forward rna-seq read", default="")
    parser.add_argument('-s2','--reverse_rna_read', help="path to reverse rna-seq read", default="")
    parser.add_argument('-iso','--isoseq', help="path to long read iso-seq read", default="")
    parser.add_argument('--aligner', help="aligner to use, hisat is defaul", choices=["hisat", "star"], default="")
    parser.add_argument('-f','--faa', 
                        help="path to protein fasta file (.faa), required for fasta_faa and fasta_rna_faa modes",
                        default="")
    parser.add_argument("-s", "--softmasked", help="use if your genome is already softmasked", default=False, action='store_true')
    parser.add_argument('-o','--outdir', help='output directory', required=True)
    parser.add_argument('-t','--threads', help='number of threads [default == 8]', default = "8")
    parser.add_argument('-d','--debug', help='debug mode', action='store_true')
    parser.add_argument('--species', help='gene model used for Augustus', default="")
    args = vars(parser.parse_args())

    assembly_fasta = os.path.abspath(args["assembly"])
    threads = args["threads"]
    debug = args["debug"]
    mode = args["mode"]
    forward_rna_read = args["forward_rna_read"]
    reverse_rna_read = args["reverse_rna_read"]
    isoseq_read = args["isoseq"]
    softmasked = args["softmasked"]
    faa_file = args["faa"]
    aligner = args["aligner"]
    outdir = os.path.abspath(args["outdir"])
    species = args["species"]
    
    execution_folder = os.path.dirname(os.path.abspath(getsourcefile(lambda: 0)))
    execution_time = datetime.now().strftime("%d_%m_%Y_%H_%M_%S")
    random_letters = "".join([random.choice(string.ascii_letters) for n in range(3)])
    config_file = os.path.join(execution_folder, f"config/config_{random_letters}{execution_time}.yaml")
    # default braker_file for fasta mode
    braker_file = os.path.join(execution_folder,"rules/braker_fasta.smk")

    if mode == "fasta_rna":
        if forward_rna_read == "0" or reverse_rna_read == "0":
            parser.error("\nfasta_rna mode requires -s1 {path_to_forward_read} and -s2 {path_to_reverse_read}!")
        else:
            forward_rna_read = os.path.abspath(forward_rna_read)
            reverse_rna_read = os.path.abspath(reverse_rna_read)
            braker_file = os.path.join(execution_folder,"rules/braker_rna.smk")
            
    elif mode == "fasta_faa":
        if faa_file == "0":
            parser.error("\nfasta_faa mode requires -f {protein_fasta.faa}!")
        else:
            faa_file = os.path.abspath(faa_file)
            braker_file = os.path.join(execution_folder,"rules/braker_faa.smk")
            
    elif mode == "fasta_rna_faa":
        if not (forward_rna_read or reverse_rna_read or faa_file):
            parser.error("\nfasta_rna_faa mode requires -s1 {path_to_forward_read} and -s2 {path_to_reverse_read} and -f {protein_fasta.faa}!")
        else:
            faa_file = os.path.abspath(faa_file)
            forward_rna_read = os.path.abspath(forward_rna_read)
            reverse_rna_read = os.path.abspath(reverse_rna_read)
            braker_file = os.path.join(execution_folder,"rules/braker_rna_faa.smk")

    elif mode == "fasta_rna_faa_isoseq":
        if not (forward_rna_read or reverse_rna_read or faa_file):
            parser.error("\nfasta_rna_faa_isoseq mode requires -s1 {path_to_forward_read} and -s2 {path_to_reverse_read} and -f {protein_fasta.faa}!")
        else:
            faa_file = os.path.abspath(faa_file)
            forward_rna_read = os.path.abspath(forward_rna_read)
            reverse_rna_read = os.path.abspath(reverse_rna_read)
            isoseq_read = os.path.abspath(isoseq_read)
            braker_file = os.path.join(execution_folder,"rules/braker_rna_faa_isoseq.smk")

    settings = {
        "assembly_fasta" : assembly_fasta,
        "fr" : forward_rna_read, 
        "rr" : reverse_rna_read,
        "iso" : isoseq_read,
        "faa" : faa_file,
        "outdir" : outdir,
        "threads" : threads,
        "mode" : mode,
        "execution_folder" : execution_folder,
        "debug" : debug,
        "softmasked" : softmasked,
        "aligner" : aligner,
        "config_file" : config_file,
        "braker_mode" : braker_file,
        "species" : species,
    }
    
    config_maker(settings, config_file)
    main(settings)
