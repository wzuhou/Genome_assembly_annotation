#!/bin/python3

from sys import argv
import sys, getopt

"""
Author: Zhou Wu
Date: 20220401
####Usage
####python [this script.py] -i <in_bed> -s <chr_size> -o <out_bed>
####python3 Parse_purge_dups.py -i test.bed -s test.chr_size -o test_test
####
"""
def main(argv):
    inputfile = ''
    chr_size = ''
    outputfile = ''
    try:
        opts, args = getopt.getopt(argv,"hi:o:s:",["ifile=","ofile=","size_chr="])
    except getopt.GetoptError:
        print('USAGE: python3 Parse_purge_dups.py -i test.bed -s test.chr_size -o test.out')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('USAGE: python3 Parse_purge_dups.py -i test.bed -s test.chr_size -o test_test ')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-s", "--size_chr"):
            chr_size = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg
    print('Input file:', inputfile)
    print('Chromosome file:', chr_size)
    print('Output file:', outputfile)
    return inputfile,chr_size,outputfile
    
    
def parse_bed(lines):
    """
    Bed=[(chrom,s_bp,e_bp,dup_type)]
    """
    Bed=[]
    count=0
    #substring='('
    chrom=''
    s_bp=""
    e_bp=""
    dup_type=''
    #species2=''
    for line in lines:
        if not line.strip():
            continue
        if line.startswith("S"):
            chrom = (line.split('\t')[0]).strip()
            #count= count-1
            s_bp = (line.split('\t')[1]).strip()
            e_bp = (line.split('\t')[2]).strip()
            dup_type = (line.split('\t')[3]).strip()
            count += 1 
            #if count ==1 :
            #    ID=(line.split('(')[1]).split(')')[0]
            #elif count == 2:
            #    ID=(line.split('(')[2]).split(')')[0]
            #elif count ==3:
            #    ID=(line.split('(')[3]).split(')')[0]
            Bed.append((chrom,s_bp,e_bp,dup_type))
            #count =0
            #print(geines)
    #Bed.append((chrom,s_bp,e_bp,dup_type))
    #print(Bed)
    return Bed

def removeDuplicates(lst):
      
    return [t for t in (set(tuple(i) for i in lst))]


def parse_size(lines):
    """
    chrom_size=[(chr_name,chr_len)]
    """
    chrom_size=[]
    chr_name=""
    chr_len=""
    for line in lines:
        if not line.strip():
            continue
        if line.startswith("S"):
            chr_name = (line.split('\t')[0]).strip()
            chr_len = (line.split('\t')[1]).strip()
            chrom_size.append((chr_name,chr_len))
    #chrom_size.append((chr_name,chr_len))
    #print(chrom_size)
    return chrom_size

def selectDup(Bed,chrom_size):
    """
    Select the duplicate type
    Bed=[(chrom,s_bp,e_bp,dup_type)]
    chrom_size=[(chr_name,chr_len)]
    Bed_filter[(chrom,s_bp,e_bp,dup_type)]
    """
    Bed_filter =[]
    chrom_len="" 
    for lst in Bed:
        
        #chrom = lst[0]+'_1'
        chrom = lst[0]
        #print(chrom)
        for i in chrom_size:
            if i[0] == chrom:
                chrom_len = i[1]
        #print(chrom_len)
        s_bp = lst[1]
        e_bp = lst[2]
        dup_type = lst[3] ###HAPLOTIG, JUNK, OVLP, REPEAT
        #check s_pos
        if s_bp =="0" or s_bp =="1":
        #if s_bp == "1":
            Bed_filter.append((chrom,s_bp,e_bp,dup_type))
            continue
        #check e_po
        elif e_bp == chrom_len:
            Bed_filter.append((chrom,s_bp,e_bp,dup_type))
        else: continue
            #check dup_type
        #Bed_filter = list(filter(lambda a: a[3] = "JUNK", Bed_filter))
    return Bed_filter



if __name__ == "__main__":
    inputfile,chr_size,outfile = main(sys.argv[1:])
    
    parse_table=parse_bed(open(inputfile))
    #parse_table2=removeDuplicates(parse_table)
    #for i in parse_table:
        #print('{0}\t{1}\t{2}\t{3}'.format(i[0],i[1],i[2],i[3]))
    

    Chrom_size=parse_size(open(chr_size))
    parse_table2 = selectDup(parse_table,Chrom_size)
    #parse_table2 = removeDuplicates(parse_table1)


    f = open(outfile,'w')
    for i in parse_table2:
        #print('{0}\t{1}\t{2}\t{3}'.format(i[0],i[1],i[2],i[3]))
        f.write("\t".join([i[0],i[1],i[2],i[3]])+"\n")
        #f.write('{0}\t{1}\t{2}\t{3}\n'.format(i[0],i[1],i[2],i[3]))
    f.close()
    
