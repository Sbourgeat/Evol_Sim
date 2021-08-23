import sys
from optparse import OptionParser, OptionGroup




parser = OptionParser()
parser.add_option("--input_cmh",dest="input_cmh",help="cmh file")
parser.add_option("--input_pvals",dest="input_pvals",help="A file with the correct p-values")
(options, args) = parser.parse_args()




PVALS = [] #List with the correct pvalues


# open p-values file
for line in open(options.input_pvals, 'r'):
    k = line.split()
    PVALS.append(k[1])


i=0
# Change the p-values in the cmh file
for line in open(options.input_cmh, "r"):
    #line = line.replace('\n','')
    k = line.split('\t')
    k[-1] = PVALS[i]
    i+=1
    print('\t'.join(k))
    #if i == 10 : break
    #print(k[-1])
