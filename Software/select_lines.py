#### Select a subset of DGRP lines
import sys
import random
from optparse import OptionParser, OptionGroup
import gzip
import numpy

parser = OptionParser()
parser.add_option("--input",dest="input",help="Haplotype file")
parser.add_option("--input_lines",dest="input_snps",help="A file containing the selected lines")
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

CHROPOS = []
for i in SNPSS:
    K = i.split('\t')
    chro = K[0]
    po = K[1]
    cp = [chro, po]
    CHROPOS.append(cp)

for line in open(options.input, 'r'):
    
    filter_line=line
        #print filter_line

##keep only snps with frequencies that range between 0.05 and 0.95

    k=filter_line.split("\t")

    chrm=k[0]
    pos=k[1]
    #print(chrm, pos)
    if [chrm, pos] in CHROPOS : print(line)







