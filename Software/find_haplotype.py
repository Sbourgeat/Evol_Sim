import sys
from optparse import OptionParser, OptionGroup
import pandas as pd
import matplotlib.pyplot as plt


parser = OptionParser()
parser.add_option("--input",dest="input",help="A file containing the dgrp haplotypes (MimicrEE input)")
(options, args) = parser.parse_args()



DF = dict()

for line in open(options.input, 'r'):
    
    filter_line=line

    k=filter_line.split("\t")

    chrm=k[0]
    pos=k[1]

    DF[[chrm,pos]] = []

    for i in range(4,len(k)):
    	DF[[chrm,pos]].append(k[i])





gzip -dc Replicate_runs/sync_files/selection_90_1.sync > selection_90_1.unz.sync



