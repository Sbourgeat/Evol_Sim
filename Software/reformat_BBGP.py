import sys
from optparse import OptionParser, OptionGroup




parser = OptionParser()
parser.add_option("--input",dest="input",help="BBGP file")
(options, args) = parser.parse_args()





# open p-values file
for line in open(options.input, 'r'):
    k = line.split()
    I = []
    for i in k:
    	i = i.split('_')
    	if len(i) >1:
    		I.append(i[0])
    		I.append(i[1])
    	else : I.append(i[0])
    print(I[0],I[1],I[2], sep = '\t')
    
    

