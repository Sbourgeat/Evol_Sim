setwd("~/Documents/DGRP_simulation/90_percent_selection/1000_SNPs")

library(ROCR)
spread<-c(0.0,0.001,0.002,0.003,0.004,0.005,0.006,0.007,0.008,0.009,0.010)


########################## BATCH 1 #####################################################

args<-commandArgs(TRUE)
alen=length(args)
filename=args[alen-1]
description=args[alen]

l1<-read.table(args[1])
f1<-read.table(args[2])

l2<-read.table(args[3])
f2<-read.table(args[4])

l1 <- read.table("label_list", quote="\"", comment.char="")
f1 <- read.table("prediction_list", quote="\"", comment.char="")

#outfile<-args[5]

prf1<-prediction(f1,l1)
prf2<-prediction(f2,l2)


######ESTIMATE TPR AND FPR FOR ROC CURVES
pef1<-performance(prf1,"tpr","fpr")
pef2<-performance(prf2,"tpr","fpr")
 



####MAKE PLOTS
postscript(file=paste("toyroc",".ps",sep=""),width=7,height=7)

par(mfrow=c(1,2))
plot(pef1,lwd=3,col="black")
plot(pef2,lwd=3,avg="vertical",spread.estimate="stderror",add=TRUE,col="red")


plot(pef1,lwd=3,col="black",show.spread.at=spread,xlim=c(0,0.01))
plot(pef2,lwd=3,avg="vertical",spread.estimate="stderror",add=TRUE,col="red",show.spread.at=spread,xlim=c(0,0.01))



legend(0.0001,0.999,legend=c("constant_selection","variable selection"),
       lty=c(1,1),lwd=c(2.5,2.5),col=c("black","red"))
dev.off()

