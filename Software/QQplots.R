#PVALS <- read.table("~/University/ENS/M2/EPFL_internship/output_G100_50.txt", quote="\"", comment.char="")
#PVALS2 <- read.table("~/University/ENS/M2/EPFL_internship/output_G100.txt", quote="\"", comment.char="")

#Import Data as PVALS

#create a list with the pvals
for(i in PVALS['V2']){}
#i <- i[1:1000000] #sub sampling for test


#for(y in PVALS2['V2']){}
#y <- y[1:10000]


#QQ plot
qqplot(qchisq(ppoints(length(i)), df = 1), i, main = 'QQ-plot', xlab = '-log10(expected p-value)', ylab = '-log10(observed p-value)')
#v2 <- qqplot(qchisq(ppoints(length(y)), df = 1), y, main = expression("Q-Q plot of the observed p-values vs the expected p-values"))
library(ggplot2)
#ggplot2::last_plot() + 
qqline(i, distribution = function(p) qchisq(p, df = 1), prob = c(0.1, 0.6), col = 2)



plot(v1$x, v1$y, col='black', main = 'QQ-plot', xlab = '-log10(expected p-value)', ylab = '-log10(observed p-value')
#points(v2$x, v2$y, col='blue')

# the theoretical distribution

#qqplot(qchisq(ppoints(length(y)), df = 1), y, main = expression("Q-Q plot of the observed p-values vs the expected p-values"))

#library(ggplot2)
#ggplot2::last_plot() + qqline(y, distribution = function(p) qchisq(p, df = 1), prob = c(0.1, 0.6), col = 2)
