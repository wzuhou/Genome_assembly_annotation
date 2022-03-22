#install manba
conda install -c conda-forge mamba
#download pipeline from git
git clone 
cd Anno_pipeline
#install dependencies
mamba env create --name Anno_pipeline --file requirements.txt

mkdir install
cd install
#install ninja
wget --no-check-certificate https://github.com/TravisWheelerLab/NINJA/archive/refs/tags/0.97-cluster_only.zip && unzip ./0.97-cluster_only.zip && mv ./NINJA-0.97-cluster_only/NINJA/Ninja_new ./NINJA-0.97-cluster_only/NINJA/Ninja
#install prothint
wget --no-check-certificate https://github.com/gatech-genemark/ProtHint/releases/download/v2.6.0/ProtHint-2.6.0.tar.gz
tar zxvf ProtHint-2.6.0.tar.gz
chmod +x ProtHint-2.6.0/bin/* & chmod +x ProtHint-2.6.0/dependencies/*
#install genemark-ex
1.Download and unzip GeneMark-EX and LICENSE_KEY from http://topaz.gatech.edu/GeneMark/license_download.cgi
2.Run change_path_in_perl_scripts.pl from Genemark folder to change perl dir to one, which is in my environment directory /path/to/miniconda/envs/braker/bin/perl
chmod +x *
3.Unzip LICENSE_KEY to hiddenfile in my home directory "gunzip ./license_key.gz" "mv ./license_key ~/.gm_key"
4.Run "check_install.bash"
5.chmod +x gmes_linux_64/ProtHint/bin/* & chmod +x gmes_linux_64/ProtHint/dependencies/*
#install genemarks-t
same as genemark-ex
#download eggnog_db (~61G)
download_eggnog_data.py --data_dir ./ -P -M -y
#download stringtie2fa.py from recent version Augustus
wget https://raw.githubusercontent.com/Gaius-Augustus/Augustus/master/scripts/stringtie2fa.py
wget https://raw.githubusercontent.com/Gaius-Augustus/BRAKER/long_reads/scripts/gmst2globalCoords.py
wget https://raw.githubusercontent.com/EVidenceModeler/EVidenceModeler/master/EvmUtils/misc/GeneMarkHMM_GTF_to_EVM_GFF3.pl
chmod +x *
#change the path in workflow/snakefile
#DONE



