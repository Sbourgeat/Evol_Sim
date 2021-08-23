import sys
import random
from optparse import OptionParser, OptionGroup
import gzip
import numpy
import pandas as pd

parser = OptionParser()
parser.add_option("--input",dest="input",help="Sync file")
parser.add_option("--input_SNPs",dest="input_snps",help="A file containing the selected SNPs")
(options, args) = parser.parse_args()



DF = pd.DataFrame()


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

CC = 0

for line in open(options.input, 'r'):
    
    filter_line=line

    k=filter_line.split("\t")

    chrm=k[0]
    pos=k[1]

    if [chrm, pos] in CHROPOS : 
        label = 1
    else :
        label = 0

    Freq = []
    Freq.append(label)
    for freq in k[3:]:
        #print(freq)
        nk = freq.split(":")
        f = []
        for i in nk:
            #print(i)
            if i != 0 : 
                f.append(int(i))
        Freq.append(max(f)/(sum(f)))

    #F = []
    #F.append(label)
    #F.append(Freq)
    #for i in range(0,21):
        #FF = []
    #    y = 0
    #    while y < i + 21*9:
    #        F.append(Freq[i + y])
    #        y += 21
            #print(FF)

        #F.append(FF)


    #print(label,'\t',"'",chrm,'_',pos,"'",'\t',F,sep='')
    #print(label,'\t',F,sep='')
    #print(len(Freq))

    df = pd.DataFrame([Freq])
    #print(df)
    DF = DF.append(df, ignore_index = True)
    CC+=1
    #print(DF)
    #if CC == 30: break

#print(DF)
DF.to_csv('DL_test/input_data.csv', index= False, header = False)






