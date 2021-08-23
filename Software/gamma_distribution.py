import numpy
import sys
import matplotlib.pyplot as plt

from optparse import OptionParser, OptionGroup

new_gamma=[]
parser = OptionParser()
parser.add_option("--num-values",dest="num",help="number of gamma values")
parser.add_option("--output",dest="output",help="File with gamma distributed values")
parser.add_option("--shape",dest="shape",help="File with gamma distributed values")
(options, args) = parser.parse_args()

writefile=open(options.output, "w")

gamma=numpy.random.gamma(float(options.shape), 1, int(options.num))

for k in range(0, len(gamma)):
	if gamma[k]<=0.000001:

		print gamma[k]
		gamma[k]=0.000001

	        new_gamma.append(gamma[k])

	else:
		new_gamma.append(gamma[k])

print new_gamma
#bins=50
#plt.hist(gamma, bins,histtype='bar', rwidth=2, color="green")
#plt.show()

for i in range(0, len(new_gamma)):
    writefile.write("%f" %new_gamma[i]+"\n")
