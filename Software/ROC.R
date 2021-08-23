setwd("~/Documents/DGRP_simulation/90_percent_selection/10_SNPs")
spread<-c(0.0,0.001,0.002,0.003,0.004,0.005,0.006,0.007,0.008,0.009,0.010)
label_list <- read.table("label_list", quote="\"", comment.char="")
prediction_list <- read.table("prediction_list", quote="\"", comment.char="")
label_list_g60 <- read.table("label_list_g60", quote="\"", comment.char="")
prediction_list_g60 <- read.table("prediction_list_g60", quote="\"", comment.char="")
label_list_g100 <- read.table("label_list_g100", quote="\"", comment.char="")
prediction_list_g100 <- read.table("prediction_list_g100", quote="\"", comment.char="")


library(ROCR)


pred <- prediction(prediction_list, label_list)
pred2 <- prediction(prediction_list_g60, label_list_g60)
pred3 <- prediction(prediction_list_g100, label_list_g100)

perf <- performance(pred,"tpr","fpr")
perf2 <- performance(pred2,"tpr","fpr")
perf3 <- performance(pred3,"tpr","fpr")



#AUC(perf@x.values[[1]], perf@y.values[[1]] )
#AUC(perf2@x.values[[1]], perf2@y.values[[1]])
#AUC(perf3@x.values[[1]], perf3@y.values[[1]])

setwd("~/Documents/DGRP_simulation/Replicate_runs_500")

library(DescTools)
library(ROCR)

l1 <- read.table("90_labels", quote="\"", comment.char="")
l2 <- read.table("80_labels", quote="\"", comment.char="")
l3 <- read.table("70_labels", quote="\"", comment.char="")
l4 <- read.table("60_labels", quote="\"", comment.char="")
l5 <- read.table("50_labels", quote="\"", comment.char="")

pl1 <- read.table("90_predictions", quote="\"", comment.char="")
pl2 <- read.table("80_predictions", quote="\"", comment.char="")
pl3 <- read.table("70_predictions", quote="\"", comment.char="")
pl4 <- read.table("60_predictions", quote="\"", comment.char="")
pl5 <- read.table("50_predictions", quote="\"", comment.char="")

pred1 <- prediction(pl1, l1)
pred2 <- prediction(pl2, l2)
pred3 <- prediction(pl3, l3)
pred4 <- prediction(pl4, l4)
pred5 <- prediction(pl5, l5)

perf <- performance(pred1,"tpr","fpr")
perf2 <- performance(pred2,"tpr","fpr")
perf3 <- performance(pred3,"tpr","fpr")
perf4 <- performance(pred4,"tpr","fpr")
perf5 <- performance(pred5,"tpr","fpr")


auc1 <- performance(pred1, measure = "auc", fpr.stop=0.01)
auc1r <- auc1@y.values[[1]]
auc1 <- as.numeric(auc1@y.values)
print(auc1r)

auc2 <- performance(pred2, measure = "auc", fpr.stop=0.01)
auc2r <- auc2@y.values[[1]]
auc2 <- as.numeric(auc2@y.values)
print(auc2r)

auc3 <- performance(pred3, measure = "auc", fpr.stop=0.01)
auc3r <- auc3@y.values[[1]]
auc3 <- as.numeric(auc3@y.values)
print(auc3r)

auc4 <- performance(pred4, measure = "auc", fpr.stop=0.01)
auc4r <- auc4@y.values[[1]]
auc4 <- as.numeric(auc4@y.values)
print(auc4r)

auc5 <- performance(pred5, measure = "auc", fpr.stop=0.01)
auc5r <- auc5@y.values[[1]]
auc5 <- as.numeric(auc5@y.values)
print(auc5r)

test12 = wilcox.test(auc1, auc2)
print(test12)

test13 = wilcox.test(auc1, auc3)
print(test13)

test14 = wilcox.test(auc1, auc4)
print(test14)

test15 = wilcox.test(auc1, auc5)
print(test15)





### AUC perf
y = 0
for(i in perf@y.values[[1]]){
  if(i <= 0.01){y = y + 1}
} 

new_yvals <- perf@y.values[[1]][1:y]
new_xvals <- perf@x.values[[1]][1:y]
print('Val for perf 1')
ONE <- AUC(new_xvals, new_yvals)


### AUC perf2

y = 0
for(i in perf@y.values[[1]]){
  if(i <= 0.01){y = y + 1}
} 
new_yvals <- perf2@y.values[[1]][1:y]
new_xvals <- perf2@x.values[[1]][1:y]
print('Val for perf 2')
TWO <- AUC(new_xvals, new_yvals)


### AUC perf3

y = 0
for(i in perf@y.values[[1]]){
  if(i <= 0.01){y = y + 1}
} 

new_yvals <- perf3@y.values[[1]][1:y]
new_xvals <- perf3@x.values[[1]][1:y]
print('Val for perf 3')
THREE <- AUC(new_xvals, new_yvals)





mylegend <- c(paste0("G20, AUC = ", ONE) ,paste0("G60, AUC =", TWO),paste0("G100, AUC = ", THREE))

#postscript(file=paste("roc",".ps",sep=""),width=7,height=7)

#png(file="figures/ROC_allgens.png",width=600,height=400)
#plot(perf, lwd=3, lty = 1)#, type = 'o', pch = 'o',)
#plot(perf2, add= TRUE, col = 'red', lty=2,lwd=3)#, pch ='*')
#plot(perf3, add=TRUE, col ='blue', lty=3, lwd=3)#, pch = '+')
#legend(0,1.0,legend=c("G20, AUC = 0.629","G60, AUC = 0.684","G100, AUC = 0.730"), col=c("black","red","blue"), lty=c(1,2,3), ncol=1)
#dev.off()


png(file="figures/ROC_allgens_partial.png",width=600,height=400)
plot(perf, lwd=3, lty = 1,xlim=c(0,0.01),show.spread.at=spread)#, type = 'o', pch = 'o',)
plot(perf2, add= TRUE, col = 'red', lty=2,lwd=3,xlim=c(0,0.01))#, pch ='*')
plot(perf3, add=TRUE, col ='blue', lty=3, lwd=3,xlim=c(0,0.01))#, pch = '+')
legend('topleft',legend=rev(mylegend), col=c("black","red","blue"), lty=c(1,2,3), ncol=1)

dev.off()


















perf2 <- performance(pred, "prec", "rec")

plot(perf2)#, avg="threshold",spread.estimate="boxplot")

##### Comparison between ROC

#G100
#AUC <- c(0.73,0.719,0.701,0.669,0.653) #1000 SNPs
#AUC <- c(0.784,0.784,0.757,0.725,0.696) # 500 SNPs
#AUC <- c(0.945,0.954,0.923,0.895,0.808) # 100 SNPs
#AUC <- c(0.943,0.959,0.968,0.97,0.851) # 50 SNPs
#AUC <- c(0.985,0.99, 0.991, 0.994,0.996) # 10 SNPs
AUC <- c(1,	1,	1,	1,	1) # 1 SNP
# G60

AUC <- c(0.684, 0.677,0.662, 0.637, 0.622) # 1000 SNPs
AUC <- c(0.731,	0.727,	0.707,	0.671,	0.653) #500 SNPs
AUC <- c(0.906,	0.893,	0.825,	0.804,	0.761) #100 SNPs
AUC <- c(0.944,	0.952,	0.903,	0.852,	0.808) # 50 SNPs
AUC <- c(0.986,	0.99,	0.992,	0.994,	0.997) # 10 SNPs
AUC <- c(1,	1,	1,	1,	1) # 1 SNP


#G20 
AUC <- c(0.629	,0.628	,0.604	,0.585	,0.564) # 1000 SNPs
AUC <- c(0.646	,0.637,	0.622	,0.604	,0.594) #500 SNPs
AUC <- c(0.733	,0.717	,0.71	,0.654	,0.646) #100 SNPs
AUC <- c(0.764	,0.79	,0.747	,0.697	,0.7) # 50 SNPs
AUC <- c(0.986	,0.991	,0.995	,0.972	,0.976) # 10 SNPs
AUC <- c(1,	1,	1,	1,	1) # 1 SNP
Y <- c('50%', '60%', '70%', '80%', '90%')

dotchart(AUC,Y, xlab = 'AURC', ylab = 'truncating selection regime', main ='10 SNPs selection efficiency')





y = 0
for(i in perf@y.values[[1]]){
  if(i <= 0.01){y = y + 1}
} 
 


