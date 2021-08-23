##########################################################
# This script takes the output of CMH test as input and  #
# identify the minimal p-value of the top 5% SNPs. This  #
# value is then used as a cut off for the assessment of  #
# different selection scenarios.                         #
#########################################################


import sys
import pandas as pd
import statistics as stat

Threshold = []

for i in range(1,len(sys.argv)):
	DF = pd.read_csv(sys.argv[i], sep = '\t', header = None)

# delete unnecessary columns

	for ii in range(2,len(DF.columns)-1):
		del DF[ii]


# Sort the DF

	DF = DF.sort_values(by=[23], ascending = False)


# Find the minimal p-value of the top 5% SNPs

	X = int(len(DF) * 5/100)
	
	PVAL = min(DF[23][:X]) 

	Threshold.append(PVAL)


print(stat.mean(Threshold))