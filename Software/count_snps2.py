import sys
import random
from optparse import OptionParser, OptionGroup
import gzip
import numpy
import timeit

start = timeit.default_timer()

parser = OptionParser()
parser.add_option("--input",dest="input",help="A file containing the dgrp haplotypes (MimicrEE input)")
parser.add_option("--input_SNPs",dest="input_snps",help="A file containing the selected SNPs")
(options, args) = parser.parse_args()


line_to_parse_freqval=[]
count_ancestral=0
count_derived=0


Loci = 0


f3 = open(options.input_snps, "r")

SNPSS = [i for i in f3]
for i in range(len(SNPSS)):
    SNPSS[i] = SNPSS[i].replace('\n','')



D = []



for line in open(options.input, 'r'):
    
    filter_line=line
        #print filter_line

##keep only snps with frequencies that range between 0.05 and 0.95

    k=filter_line.split("\t")

    chrm=k[0]
    pos=k[1]
    ancestral,derived=k[3].split("/")
    alleles=[k[i] for i in range(4,len(k))]
    #print('allele = ', len(alleles))
    count_ancestral=0
    count_derived=0

    #if chrm== '2R': break

    for j in range(0, len(alleles)):
        allele_to_count=alleles[j]

        if allele_to_count.rstrip()==str(ancestral*2):
            count_ancestral=count_ancestral+1

        elif allele_to_count.rstrip()==str(derived*2):
            count_derived=count_derived+1
    
    freq_ancestral=float(count_ancestral) / len(alleles)
    freq_derived=float(count_derived) / len(alleles)

    if freq_ancestral != 1.0 and freq_ancestral != 0.0: 
        #Loci+=1
        cp = [chrm,pos]
        D.append(cp)
        #print(SNPSS[ii])
        #print(D)
        #print('the chrp and pos are', chrm, pos, 'ancestral = ', freq_ancestral, 'derived =', freq_derived)




    #print('the chrp and pos are', chrm, pos, 'ancestral = ', freq_ancestral, 'derived =', freq_derived)
            

#print('The number of Loci with more than one SNP is =', Loci)




for i in SNPSS:
    K = i.split('\t')
    chro = K[0]
    po = K[1]
    cp = [chro, po]
    if cp in D:
        print(i)





