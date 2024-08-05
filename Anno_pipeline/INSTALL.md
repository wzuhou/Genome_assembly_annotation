### install manba  
```bash
conda install -c conda-forge mamba
```

### download pipeline from git  
```bash
git clone  
cd Anno_pipeline
```

### install dependencies  
```bash
mamba env create --name Anno_pipeline --file requirements.txt
```

```bash
mkdir install  
cd install  
```

### install ninja  
```bash
wget --no-check-certificate https://github.com/TravisWheelerLab/NINJA/archive/refs/tags/0.97-cluster_only.zip && unzip ./0.97-cluster_only.zip && cd NINJA-0.97-cluster_only/NINJA && make && cd ../..  
```

### install prothint  
```bash
wget --no-check-certificate https://github.com/gatech-genemark/ProtHint/releases/download/v2.6.0/ProtHint-2.6.0.tar.gz  
tar zxvf ProtHint-2.6.0.tar.gz  
chmod +x ProtHint-2.6.0/bin/* && chmod +x ProtHint-2.6.0/dependencies/*  
```

### install genemark-ex  
1.Download and unzip GeneMark-EX and LICENSE_KEY from http://topaz.gatech.edu/GeneMark/license_download.cgi  ( GeneMark-ES/ET/EP+ ver 4.72_lic/LINUX 64 kernel 3.10 - 5; GeneMarkS-T/LINUX 64)
```bash
cd gmes_linux_64_4
```
2.Run `change_path_in_perl_scripts.pl` from Genemark folder to change perl dir to one, which is in my conda environment directory 
/path/to/miniconda/envs/Anno_pipeline/bin/perl  
```bash
perl change_path_in_perl_scripts.pl "/path/to/miniconda/envs/Anno_pipeline/bin/perl"
chmod +x * 
chmod +x ProtHint/bin/*
```

3.Unzip LICENSE_KEY to hiddenfile in my home directory "gunzip ./license_key.gz" "mv ./license_key ~/.gm_key"  
4.Run "check_install.bash"  
5.chmod +x gmes_linux_64_4/ProtHint/bin/* & chmod +x gmes_linux_64/ProtHint/dependencies/*  

### install genemarks-t  

same as genemark-ex (optional)


### download eggnog_db (~61G)  
```bash
download_eggnog_data.py --data_dir ./ -P -M -y  
```

### download stringtie2fa.py from recent version Augustus  
```bash
wget https://raw.githubusercontent.com/Gaius-Augustus/Augustus/master/scripts/stringtie2fa.py  
wget https://raw.githubusercontent.com/Gaius-Augustus/BRAKER/long_reads/scripts/gmst2globalCoords.py  
wget https://raw.githubusercontent.com/EVidenceModeler/EVidenceModeler/master/EvmUtils/misc/GeneMarkHMM_GTF_to_EVM_GFF3.pl  
chmod +x *  
```

### change the path in workflow/snakefile  

```bash
#line 35-42
        ninja_path = "/dss/dsslegfs01/pr53da/pr53da-dss-0035/2022__Coturnix/Annotation/test_pipline/Anno_pipeline/install/NINJA-0.97-cluster_only/NINJA",
        prothint_path = "/dss/dsslegfs01/pr53da/pr53da-dss-0035/2022__Coturnix/Annotation/test_pipline/Anno_pipeline/install/ProtHint-2.6.0/bin",
        genemark_path = "/dss/dsslegfs01/pr53da/pr53da-dss-0035/2022__Coturnix/Annotation/test_pipline/Anno_pipeline/install/gmes_linux_64",
        gmst_path = "/dss/dsslegfs01/pr53da/pr53da-dss-0035/2022__Coturnix/Annotation/test_pipline/Anno_pipeline/install/gmst_linux_64_4",
        stringtie2fa_path = "/dss/dsslegfs01/pr53da/pr53da-dss-0035/2022__Coturnix/Annotation/test_pipline/Anno_pipeline/install",
        gmst2globalCoords = "/dss/dsslegfs01/pr53da/pr53da-dss-0035/2022__Coturnix/Annotation/test_pipline/Anno_pipeline/install",
        eggnog_db = "/dss/dsslegfs01/pr53da/pr53da-dss-0035/2022__Coturnix/Annotation/test_pipline/test/eggnog_db",
        #what about this one? GeneMarkHMM_GTF_to_EVM_GFF3
```
### DONE  



