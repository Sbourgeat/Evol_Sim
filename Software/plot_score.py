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


Res = dict()

names = ['90%','80%','70%','60%','50%']

for i in range(1, len(sys.argv)):

	Res[names[i-1]] = []

	r = open(sys.argv[i])

	for ii in r :
		Res[names[i-1]].append(float(ii))



df = pd.DataFrame(Res)

plt.style.use('ggplot')

boxplot = df.boxplot(column=names)

plt.xlabel('Selection scenario')
plt.ylabel('Efficiency score (%)')
plt.show()

