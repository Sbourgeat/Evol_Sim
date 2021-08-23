##set current working directory
##the function takes three arguments as input: the file containg the results from the cmh test, the file that specifies the targets of selection and the p-value above which results are plotted.

setwd("~/Documents/DGRP_simulation/BBGP-master/R/results_var_envi")

#test.cmh <- read.delim("~/Documents/DGRP_simulation/Mock_2/dgrp_qtl.cmh", header=FALSE) #problem with the test or simulation
#test.snp <- read.delim("~/Documents/DGRP_simulation/Data/effect_sizes_1.txt", header=FALSE)

test.cmh <- read.delim("BBGP_new", header=FALSE)
test.snp <- read.delim("~/Documents/DGRP_simulation/variable_environment/effect-size", header=FALSE)
#pval <- read.table("~/Documents/DGRP_simulation/Random_snps100/output_G100_50.txt", quote="\"", comment.char="")
#Not necessary if corrected cmh file!


repl=10
cl.to.rm=3+repl*6
test.cmh<-test.cmh[-c(4:cl.to.rm,25)]
#test.cmh['V64'] <- pval['V2']

make.mhp<- function(cmh.file, snp.file,minp){
  
  #cmh.file<-subset(cmh.file,V3>=minp)
  
  chrm<- cmh.file[,1]
  pos<-  cmh.file[,2]
  pval<- cmh.file[,3]
  
  chosen_snps<-paste(snp.file[,1],snp.file[,2],sep="")
  chosen_matr<- matrix(NA, ncol=4, nrow=length(chosen_snps))
  
  #print(cmh.file)
  
  for(i in 1:length(chosen_snps)){
    print(i)
    print(chosen_snps[i])
    print((as.character(cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),1])))
    print((as.character(cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),2])))
    print((as.character(cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),3])))
    if(cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),3] < 0){cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),3] <- 0}
    chosen_matr[i,1]<-(as.character(cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),1]))
    chosen_matr[i,2]<-(as.character(cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),2]))
    #print(cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),3])
    chosen_matr[i,3]<-(as.character(cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),3]))
    #print(chosen_matr[i,3])
    
  }
  
  
  chosen_matr[,4]<-"chosen"
  
  
  '%!in%' <- function(x,y)!('%in%'(x,y))
  non_chosen_matr<- matrix(NA, ncol=4, nrow=nrow(cmh.file))
  for(i in 1:nrow(cmh.file)){
    
    chrmpos<- paste(cmh.file[i,1],cmh.file[i,2],sep="")
    if(chrmpos %!in% chosen_snps){
      non_chosen_matr[i,1]<-as.character(cmh.file[i,1])
      non_chosen_matr[i,2]<-cmh.file[i,2]
      non_chosen_matr[i,3]<-cmh.file[i,3]
    }
  }
  non_chosen_matr[,4]<-"non_chosen"
  to.rm<- which(is.na(non_chosen_matr[,1]))   
  
  
  non_chosen_matr<- non_chosen_matr[-to.rm,]
  
  
  
  file_for_mhp_non_chosen<-data.frame(chrom=non_chosen_matr[,1], position=as.numeric(non_chosen_matr[,2]), pvalues=as.numeric(non_chosen_matr[,3]), snps=non_chosen_matr[,4])  
  file_for_mhp_chosen<-data.frame(chrom=chosen_matr[,1], position=as.numeric(chosen_matr[,2]),pvalues=as.numeric(chosen_matr[,3]),snps=chosen_matr[,4])  
  
  file_for_mhp<- rbind(file_for_mhp_non_chosen,file_for_mhp_chosen)  
  print(is.numeric(file_for_mhp[,2]))
  print(is.numeric(file_for_mhp[,3]))
  
  
  p<-ggplot(file_for_mhp, aes(x=position, y=pvalues, color=snps, size=snps)) + geom_point()+ scale_color_manual(values=c("firebrick", "grey")) +
    scale_x_continuous(breaks=c(0,5000000,10000000,15000000,20000000,25000000),
                       labels=c("0","5","10","15","20","25"))+
    scale_y_continuous(breaks=c(0,500,1000,1500,2000,2500,3000,3500,4000,4500,5000,10000,100000), labels=c("0","500","1000","1500","2000","2500","3000","3500","4000","4500","5000","10000","100000"))+
    #ylim(0, 1000)+
    theme_bw() + 
    labs(x="chromosome coordinates (Mb)", y=expression(-log[10](P))) + scale_size_manual(values=c(0.3,1))+
    facet_grid(.~chrom, scales="free_x", space="free_x")+
    theme(axis.text.x = element_text(size=12), axis.text.y=element_text(size=12),axis.title.x = element_text(size=12), axis.title.y=element_text(size=12),legend.position="none")
  return(p)
}

library(ggplot2)
mhp<-make.mhp(test.cmh,test.snp,0)

png(file="Res_g100.png",width=600,height=400)
print(mhp)
dev.off()









#export data

write.table(test.cmh, file = "Data_cmh.txt", sep = "\t",
            row.names = FALSE, col.names = FALSE, quote = FALSE)
