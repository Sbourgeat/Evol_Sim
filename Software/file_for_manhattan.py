from optparse import OptionParser, OptionGroup


parser = OptionParser()
parser.add_option("--input-cmh",dest="data" ,help="Output file from cmh-test.pl with p-values")
parser.add_option("--input-snps",dest="snps" ,help="Input file with selected snps")
(options, args) = parser.parse_args()


with open(options.data, 'r') as f:
    data=f.readlines()

with open(options.snps, 'r') as f:
    snps=f.readlines()

for line in snps:
    k=line.split("\t")
    for line2 in data:
        j=line2.split("\t")

        if k[0]==j[0] and k[1]==j[1]:
            print j[0],j[1],j[-1].strip(),"chosen"
