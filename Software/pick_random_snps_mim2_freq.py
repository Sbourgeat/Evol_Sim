import sys
import random
from optparse import OptionParser, OptionGroup
import gzip
import numpy
import timeit

start = timeit.default_timer()

parser = OptionParser()
parser.add_option("--input",dest="input",help="A file containing the dgrp haplotypes (MimicrEE input)")
parser.add_option("--output",dest="output",help="A file containing the randomly selected SNPs")
parser.add_option("--output-freq",dest="output2",help="A file containing the allele frequencies")
parser.add_option("--snp-number",dest="snps", help="Number of selected SNPs")
parser.add_option("--gamma-input", dest="gamma", help="gamma distribution input file")
parser.add_option("--first-filter", dest="first_filtering", help="Proportion of lines after which filtering will be applied")
(options, args) = parser.parse_args()

rndm=None
gamma_list=[]
line_to_parse_freqval=[]
count_ancestral=0
count_derived=0
rndm2=None


writefile=open(options.output, 'w')
writefile2=open(options.output2, 'w')

##shuffle gamma values
for line in open(options.gamma, 'r'):
    gamma_list.append(line)

gamma_list=random.sample(gamma_list, len(gamma_list))

##keep one line after every ....

for line in open(options.input, 'r'):
    rndm2=random.random()

    if rndm2<=float(options.first_filtering):
        filter_line=line
        #print filter_line

##keep only snps with frequencies that range between 0.05 and 0.95

        k=filter_line.split("\t")

        chrm=k[0]
        pos=k[1]
        ancestral,derived=k[3].split("/")
        alleles=[k[i] for i in range(4,len(k))]



        for j in range(0, len(alleles)):
            allele_to_count=alleles[j]

            if allele_to_count.rstrip()==str(ancestral*2):
                count_ancestral=count_ancestral+1

            elif allele_to_count.rstrip()==str(derived*2):
                count_derived=count_derived+1

        #print('the chrp and pos are', chrm, pos, 'ancestral = ', count_ancestral, 'derived =', count_derived)
        freq_ancestral=float(count_ancestral) / len(alleles)
        freq_derived=float(count_derived) / len(alleles)
        #print('the chrp and pos are', chrm, pos, 'ancestral = ', freq_ancestral, 'derived =', freq_derived)
        #print(freq_ancestral,'ancestral')
        #print(freq_derived, 'derived')


        if freq_ancestral>0.95 or freq_derived>0.95 :
            writefile2.writelines(pos+"\t"+"%f" %freq_ancestral+ "\t" + "%f" %freq_derived+"\t" +"NOT PASS"+"\n")
        else:
            line_to_parse_freqval.append(line)
            writefile2.writelines(pos+"\t"+ "%f" %freq_ancestral+ "\t" + "%f" %freq_derived+"\t" +"PASS"+"\n")

        count_ancestral, count_derived= 0,0

##keep random lines(snps)

if len(line_to_parse_freqval)>= int(options.snps):
    random_lines=random.sample(line_to_parse_freqval, int(options.snps))

else:
    raise ValueError("Number of random snps greater than the total number of alleles")


for j in range(0, int(options.snps)):

    line_to_parse2=random_lines[j]

    k2=line_to_parse2.split("\t")

    chrm2=k2[0]
    pos2=k2[1]
    ancestral2,derived2=k2[3].split("/")
    alleles2=k2[4].split(" ")

##keep ancestral or derived allele randomly
    rndm=random.random()
    if rndm>=0.50:
        allele=ancestral2
        opposite_allele=derived2

    elif rndm<0.50:
        allele=derived2
        opposite_allele=ancestral2

##assign random + and - at the gamma values
    rndm_sign=random.random()

    if rndm_sign>=0.50:
        gamma_list[j]=float(gamma_list[j])
        writefile.writelines(chrm2+"\t"+ pos2 +"\t"+allele+"/"+opposite_allele+"\t"+"%f" %gamma_list[j]+"\t"+"%d" %0+"\n")

##change alleles and signs when sign is negative
    elif rndm_sign<0.50:
        gamma_list[j]= - float(gamma_list[j])

        if allele==ancestral2:
            allele=derived2
            opposite_allele=ancestral2
            writefile.writelines(chrm2+"\t"+ pos2 +"\t"+allele+"/"+opposite_allele+"\t"+ "%f" %-gamma_list[j]+"\t"+"%d" %0+"\n")
        elif allele==derived2:
            allele=ancestral2
            opposite_allele=derived2
            writefile.writelines(chrm2+"\t"+ pos2 +"\t"+allele+"/"+opposite_allele+"\t"+"%f" %-gamma_list[j]+"\t"+"%d" %0+"\n")

writefile.close()
writefile2.close()


stop = timeit.default_timer()

print "Elapsed time (sec):", (stop - start)
