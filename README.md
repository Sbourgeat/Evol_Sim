# Evol_Sim
Guide to use MimicrEE2 with some codes that will help you simulate and analyse the data quickly!

Important addresses:
https://sourceforge.net/p/mimicree2/wiki/Home/
https://sourceforge.net/p/popoolation2/wiki/Main/

Prerequisites:

	- Python 2 and 3
	- Perl
	- Java
	- R
	- RStudio
	- MacOS or Linux recommended!

Files organization :

- The output file of MimicrEE2 contains the genomic data of the replicates and the original population. If we need an output after n generations and for 10 replicates, we’ll get : base_F0   Rep1_F0  base_F0  Rep2_F0 …… baseF_10  Rep10_F10

- Examples of input codes are given in the file: Tutorial_Code 

- To perform a CMH test with the data obtained after simulation we have to:
	1) Use Popoolation script to get the .rin file
	2) Format this file using the script format_cmh.py
	3) Create the R code to perform the test (it is available under the name cmh.R)
	4) Run the following command in terminal in the right wd R —vanilla —slave <“input.R” >”output.txt”
	5) Create the Manhattan plot either using Rstudio or R o terminal with the command R —vanilla —slave <“input.R” 
