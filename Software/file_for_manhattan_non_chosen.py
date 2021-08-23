from optparse import OptionParser, OptionGroup


parser = OptionParser()
parser.add_option("--input-cmh",dest="data" ,help="Output file from cmh-test.pl with p-values")
parser.add_option("--input-snps",dest="snps" ,help="Input file with chosen snps")
(options, args) = parser.parse_args()


with open(options.data, 'r') as f:
    data=f.readlines()

with open(options.snps, 'r') as f:
    snps=f.readlines()

common=[]
for line2 in snps:
    j=line2.split()
    common.append(j[0]+j[1])


for line in data:
    k=line.split("\t")

    if k[0]+k[1] in common:
        continue
    else:
        print k[0], k[1], k[-1].strip(), "non_chosen"
