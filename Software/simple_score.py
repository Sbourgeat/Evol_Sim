##########################################################
# This script takes the output of CMH test as input and  #
# score the selection regime by calculating the ratio    #
# between the number of causative loci found amongst all #
# the loci above a certain threshold calculated with     #
# threshold.py 											 #
#########################################################


import sys
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


R = []

label = pd.read_csv(sys.argv[1], sep = '\t', header = None)
label = label[0]

for i in open(sys.argv[2]):
	Threshold = i
	Threshold = Threshold.replace('\n','')
	Threshold = float(Threshold)
	break



DF = pd.read_csv(sys.argv[3], sep = '\t', header = None)

X = len(DF.columns)-1
# delete unnecessary columns

for ii in range(2,len(DF.columns)-1):
	del DF[ii]


# Sort the DF

	#DF = DF.sort_values(by=[23], ascending = False)


# Create a list with all the SNPs above the threshold

#print(X)

L=[]
for ii in range(len(DF[X])):
	if DF[X][ii] > Threshold:
		#print('GO')
		L.append((DF[0][ii], DF[1][ii],label[ii]))


ctn = 0

for ii in L :
	if ii[2] == 1 : ctn +=1
	
	#print('count =', ctn)
Res = (ctn / len(L)) * 100 
R.append(Res)


#fig1, ax1 = plt.subplots()
#ax1.set_title('Score')
#ax1.boxplot(R)

#plt.show()

for i in R:
	print(i)