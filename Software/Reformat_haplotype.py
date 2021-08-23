import sys
import random
from optparse import OptionParser, OptionGroup
import gzip
import numpy

parser = OptionParser()
parser.add_option("--input",dest="input",help="G0 haplotype file ")
parser.add_option("--input_G100",dest="input_G100",help="New haplotype file")
(options, args) = parser.parse_args()

L = []

for line in open(options.input_G100, 'r'):
    
    filter_line=line

    k=filter_line.split("\t")
    k = k[4].split(' ')

    L.append(k)
    #break

#print(L)

ctn = 0
for line in open(options.input, 'r'):
    
    filter_line=line

    k=filter_line.split("\t")

    chrm=k[0]
    pos=k[1]

    print(chrm,'\t', pos,'\t',k[2],'\t',k[3], end='\t')

    X = 680
    for i in range(4,X):
    	#print(i)
    	if i == X-1:	
    		print(k[i], end='\t')
    		print(L[ctn][i], end='\n')
    	else:	
    		print(k[i], end='\t')
    		print(L[ctn][i], end='\t')
    #print('\n')
    #if ctn == 2 : break
    ctn +=1


