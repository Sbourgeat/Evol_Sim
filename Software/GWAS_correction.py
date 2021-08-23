import sys
import random
from optparse import OptionParser, OptionGroup
import gzip
import numpy

parser = OptionParser()
parser.add_option("--input",dest="input",help="GWAS result file")
parser.add_option("--input2",dest="input2",help="effect sizes file")
(options, args) = parser.parse_args()


ES = dict()


for line in open(options.input2, 'r'):
    
    filter_line=line

    k=filter_line.split("\t")

    ES[k[0]+k[1]] = [k[0],k[1],k[2],k[3]]
    #break

#print(L)

ctn = 0
for line in open(options.input, 'r'):
    
    filter_line=line

    k=filter_line.split("\t")


    chrm=k[0]
    pos=k[1]
    allele = k[2]

    if chrm+pos in ES.keys() :
        print(chrm,pos,allele,sep='\t')

        