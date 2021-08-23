#setwd("/path/to/my/files/")
#test.cmh<- read.table("dgrp_qtl.cmh")
#test.snp<- read.table("effect_sizes_1.txt")
test.cmh <- read.delim("~/Documents/DGRP_simulation/Mock/cmh_files/dgrp.cmh", header=FALSE)
test.snp <- read.delim("~/Documents/DGRP_simulation/Data/effect_sizes_1.txt", header=FALSE)




repl=10
cl.to.rm=3+repl*2
test.cmh<-test.cmh[-c(4:cl.to.rm,25)]


make.mhp<- function(cmh.file, snp.file){
  
  
  chrm<- cmh.file[,1]
  pos<-  cmh.file[,2]
  pval<- cmh.file[,4]
  
  chosen_snps<-paste(snp.file[,1],snp.file[,2],sep="")
  chosen_matr<- matrix(NA, ncol=4, nrow=length(chosen_snps))
  
  
  for(i in 1:length(chosen_snps)){
    
    chosen_matr[i,1]<-(as.character(cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),1]))
    chosen_matr[i,2]<-(as.character(cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),2]))
    chosen_matr[i,3]<-(as.character(cmh.file[which(paste(chrm,pos, sep="")==chosen_snps[i]),4]))
  }
  
  
  chosen_matr[,4]<-"chosen"
  
  
  '%!in%' <- function(x,y)!('%in%'(x,y))
  non_chosen_matr<- matrix(NA, ncol=4, nrow=nrow(cmh.file))
  for(i in 1:nrow(cmh.file)){
    
    chrmpos<- paste(cmh.file[i,1],cmh.file[i,2],sep="")
    if(chrmpos %!in% chosen_snps){
      non_chosen_matr[i,1]<-as.character(cmh.file[i,1])
      non_chosen_matr[i,2]<-cmh.file[i,2]
      non_chosen_matr[i,3]<-cmh.file[i,4]
    }
  }
  non_chosen_matr[,4]<-"non_chosen"
  to.rm<- which(is.na(non_chosen_matr[,1]))   
  
  
  non_chosen_matr<- non_chosen_matr[-to.rm,]
  
  
  
  file_for_mhp_non_chosen<-data.frame(chrom=non_chosen_matr[,1], position=as.numeric(non_chosen_matr[,2]), pvalues=as.numeric(non_chosen_matr[,3]), snps=non_chosen_matr[,4])  
  file_for_mhp_chosen<-data.frame(chrom=chosen_matr[,1], position=as.numeric(chosen_matr[,2]),pvalues=as.numeric(chosen_matr[,3]),snps=chosen_matr[,4])  
  
  file_for_mhp<- rbind(file_for_mhp_non_chosen,file_for_mhp_chosen)  
  file_for_mhp
  
  ggplot(file_for_mhp, aes(x=position, y=pvalues, color=snps, size=snps)) + geom_point()+ scale_color_manual(values=c("grey", "firebrick")) +
    scale_x_continuous(breaks=c(0,5000000,10000000,15000000,20000000,25000000),
                       labels=c("0","5","10","15","20","25"))+
    scale_y_continuous(breaks=c(0,500,1000,1500), labels=c("0","500","1000","1500"))+
    ylim(0, 1500)+
    theme_bw() + 
    labs(x="Chromosome Coordinates (Mb)", y=expression(-log[10](P))) + scale_size_manual(values=c(0.3,1))+
    facet_grid(.~chrom, scales="free_x", space="free_x")+
    theme(axis.text.x = element_text(size=15), axis.text.y=element_text(size=15),axis.title.x = element_text(size=15), axis.title.y=element_text(size=15),legend.position="none")
  
}

make.mhp(test.cmh, test.snp)