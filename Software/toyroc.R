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

l3<-read.table(args[5])
f3<-read.table(args[6])

l4<-read.table(args[7])
f4<-read.table(args[8])

l5<-read.table(args[9])
f5<-read.table(args[10])


#outfile<-args[5]

prf1<-prediction(f1,l1)
prf2<-prediction(f2,l2)
prf3<-prediction(f3,l3)
prf4<-prediction(f4,l4)
prf5<-prediction(f5,l5)


######ESTIMATE TPR AND FPR FOR ROC CURVES
pef1<-performance(prf1,"tpr","fpr")
pef2<-performance(prf2,"tpr","fpr")
pef3<-performance(prf3,"tpr","fpr")
pef4<-performance(prf4,"tpr","fpr")
pef5<-performance(prf5,"tpr","fpr")



####MAKE PLOTS
postscript(file=paste("toyroc",".ps",sep=""),width=7,height=7)

par(mfrow=c(1,2))
plot(pef1,lwd=3,avg="vertical",spread.estimate="stderror",col="black")
plot(pef2,lwd=3,avg="vertical",spread.estimate="stderror",add=TRUE,col="red")
plot(pef3,lwd=3,avg="vertical",spread.estimate="stderror",add=TRUE,col="darkgreen")
plot(pef4,lwd=3,avg="vertical",spread.estimate="stderror",add=TRUE,col="blue")
plot(pef5,lwd=3,avg="vertical",spread.estimate="stderror",add=TRUE,col="darkgoldenrod1")


plot(pef1,lwd=3,avg="vertical",spread.estimate="stderror",col="black",show.spread.at=spread,xlim=c(0,0.01))
plot(pef2,lwd=3,avg="vertical",spread.estimate="stderror",add=TRUE,col="red",show.spread.at=spread,xlim=c(0,0.01))
plot(pef3,lwd=3,avg="vertical",spread.estimate="stderror",add=TRUE,col="darkgreen",show.spread.at=spread,xlim=c(0,0.01))
plot(pef4,lwd=3,avg="vertical",spread.estimate="stderror",add=TRUE,col="blue",show.spread.at=spread,xlim=c(0,0.01))
plot(pef5,lwd=3,avg="vertical",spread.estimate="stderror",add=TRUE,col="darkgoldenrod1",show.spread.at=spread,xlim=c(0,0.01))


legend(0.0001,0.999,legend=c("90%","80%","70%","60%","50%"),
       lty=c(1,1,1,1,1),lwd=c(2.5,2.5,2.5,2.5,2.5),col=c("black","red","darkgreen","blue","darkgoldenrod1"))
dev.off()

