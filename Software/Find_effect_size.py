import sys
import random
from optparse import OptionParser, OptionGroup
import gzip
import numpy

parser = OptionParser()
parser.add_option("--input",dest="input",help="csv file with the most significative SNPs")
parser.add_option("--input2",dest="input2",help="effect sizes file")
(options, args) = parser.parse_args()


ES = dict()


for line in open(options.input2, 'r'):
    
    filter_line=line

    k=filter_line.split("\t")

    ES[k[0]+k[1]] = k
    #break

#print(L)

ctn = 0
for line in open(options.input, 'r'):
    
    filter_line=line

    k=filter_line.split(",")


    chrm=k[0]
    pos=k[1]

    if chrm+pos in ES.keys() :
        print(k[0],k[1],k[2],ES[chrm+pos][3],ES[chrm+pos][2].split('/')[1], sep=',')
        ctn += 1