import sys
from optparse import OptionParser, OptionGroup




parser = OptionParser()
parser.add_option("--input",dest="input",help="effect sizes file")
(options, args) = parser.parse_args()





# open p-values file
for line in open(options.input, 'r'):
    k = line.split()
    print(k[0],'_',k[1], sep='')

