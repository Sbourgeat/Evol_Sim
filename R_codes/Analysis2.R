
setwd("~/Documents/DGRP_simulation/more_rep")

#test.cmh <- read.delim("~/Documents/DGRP_simulation/Mock_2/dgrp_qtl.cmh", header=FALSE) #problem with the test or simulation
#test.snp <- read.delim("~/Documents/DGRP_simulation/Data/effect_sizes_1.txt", header=FALSE)

test.cmh <- read.delim("Scoring/selection_G_corrected.cmh", header=FALSE)
test.snp <- read.delim("Scoring/effect-size_batch_9", header=FALSE)
#pval <- read.table("~/Documents/DGRP_simulation/Random_snps100/output_G100_50.txt", quote="\"", comment.char="")
#Not necessary if corrected cmh file!


test.cmh['V4'] <- -log10(test.cmh['V4'])

val_thres = CalcThreshold(test.cmh)
val_thres

threshold = 6.91525 

#test.cmh['V5'] <- p.adjust(p, method = 'BH', n = length(p))


p = unlist(test.cmh['V4'])
p = as.numeric(p)

R = c()
for(i in p){
  if(i >= threshold){
    R = list.append(R,i)
  }
}



repl=10
cl.to.rm=258

repl=20
cl.to.rm=3+repl*2
test.cmh<-test.cmh[-c(4:cl.to.rm,25)]
#test.cmh<-test.cmh[-c(4:258,25)]

#test.cmh['V64'] <- pval['V2']



make.mhp<- function(cmh.file, snp.file){
  
  
  chrm<- cmh.file[,1]
  pos<-  cmh.file[,2]
  pval<- cmh.file[,4]
  
  chosen_snps<-paste(snp.file[,1],snp.file[,2],sep="")
  chosen_matr<- matrix(NA, ncol=4, nrow=length(chosen_snps))
  
  
  for(i in 1:length(chosen_snps)){
    print(i)
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
  
  p<-ggplot(file_for_mhp, aes(x=position, y=pvalues, color=snps, size=snps)) + geom_point()+ scale_color_manual(values=c("firebrick", "grey")) +#scale_size_manual(values=c(3,1))+
    scale_x_continuous(breaks=c(0,5000000,10000000,15000000,20000000,25000000),
                       labels=c("0","5","10","15","20","25"))+
    #scale_y_continuous(breaks=c(0,500,1000,1500,2000,2500,3000,3500,4000,4500,5000,10000,100000), labels=c("0","500","1000","1500","2000","2500","3000","3500","4000","4500","5000","10000","100000"))+
    #ylim(0, 1000)+
    #theme_classic() + 
    theme_bw() + 
    labs(x="chromosome coordinates (Mb)", y=expression(-log[10](P))) + scale_size_manual(values=c(2,1))+
    #ggtitle("E&R with 50 causative loci after 100 generations of selection")+
    facet_grid(.~chrom, scales="free_x", space="free_x")+
    theme(axis.text.x = element_text(size=18), axis.text.y=element_text(size=18),axis.title.x = element_text(size=24), axis.title.y=element_text(size=24),legend.position="none",strip.text.x = element_text(size = 18))+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"))+
    geom_hline(yintercept=88.89849)# +
    #geom_hline(yintercept=threshold)
    #title("E&R after 100 generations")
  return(p)
}


library(ggplot2)
mhp<-make.mhp(test.cmh,test.snp)

png(file="res_20rep.png",width=1098,height=381)
print(mhp)
dev.off()

mhp







CalcThreshold <- function(input, sig.level = 0.05, method = "BH") {
  # define a function
  qvalue_tmp <- function(p) {
    smooth.df <- 3
    
    if(min(p) < 0 || max(p) > 1) {
      stop("P-values not in valid range.")
      return(0)
    }
    
    lambda <- seq(0, 0.90, 0.05)
    m <- length(p)
    
    pi0 <- rep(0, length(lambda))
    for(i in 1:length(lambda)) {
      pi0[i] <- mean(p >= lambda[i]) / (1 - lambda[i])
    }
    
    spi0 <- smooth.spline(lambda, pi0, df = smooth.df)
    pi0 <- predict(spi0, x = max(lambda))$y
    pi0 <- min(pi0, 1)
    
    if(pi0 <= 0) {
      stop("The estimated pi0 <= 0. Check that you have valid p-values.")
      return(0)
    }
    
    #The estimated q-values calculated here
    u <- order(p)
    
    # ranking function which returns number of observations less than or equal
    qvalue.rank <- function(x) {
      idx <- sort.list(x)
      
      fc <- factor(x)
      nl <- length(levels(fc))
      bin <- as.integer(fc)
      tbl <- tabulate(bin)
      cs <- cumsum(tbl)
      
      tbl <- rep(cs, tbl)
      tbl[idx] <- tbl
      
      return(tbl)
    }
    
    v <- qvalue.rank(p)
    
    qvalue <- pi0 * m * p / v
    qvalue[u[m]] <- min(qvalue[u[m]], 1)
    for(i in (m-1):1) {
      qvalue[u[i]] <- min(qvalue[u[i]], qvalue[u[i + 1]], 1)
    }
    
    return(qvalue)
  }
  
  input <- input[!is.na(input[, 4]), , drop = FALSE]
  input <- input[order(input[, 2], input[, 3]), ]
  
  method[!(method %in% c("BH", "Bonf"))] <- "BH"
  methods <- rep(method, each = length(sig.level))
  sig.levels <- rep(sig.level, length(method))
  
  n.thres <- length(methods)
  
  thresholds <- rep(NA, n.thres)
  for(thres.no in 1:n.thres){
    method.now <- methods[thres.no]
    sig.level.now <- sig.levels[thres.no]
    
    if(method.now == "BH"){
      # input should be a result object of GWAS in {rrBLUP} package
      q.ans <- qvalue_tmp(10 ^ (- input[, 4]))
      temp <- cbind(q.ans, input[, 4])
      temp <- temp[order(temp[, 1]), ]
      if (temp[1, 1] < sig.level.now) {
        temp2 <- tapply(temp[, 2], temp[, 1], mean)
        qvals <- as.numeric(rownames(temp2))
        x <- which.min(abs(qvals - sig.level.now))
        first <- max(1, x - 2)
        last <- min(x + 2, length(qvals))
        if ((last - first) < 4) {
          last <- first + 3
        }
        
        if(sum(is.na(qvals[first:last])) == 1){
          qvals[last] <- mean(qvals[first + 1] + qvals[first + 2])
          temp2[last] <- mean(temp2[first + 1] + temp2[first + 2])
        }
        
        if(sum(is.na(qvals[first:last])) == 2){
          qvals[(last - 1):last] <- quantile(qvals[first:(first + 1)], probs = c(1 / 3, 2 / 3))
          temp2[(last - 1):last] <- quantile(temp2[first:(first + 1)], probs = c(1 / 3, 2 / 3))
        }
        
        qvals <- sort(qvals)
        temp2 <- temp2[order(qvals)]
        
        splin <- smooth.spline(x = qvals[first:last], y=temp2[first:last], df = 3)
        threshold <- predict(splin, x = sig.level.now)$y
      }else{
        threshold <- NA
      }
    }
    
    if(method.now == "Bonf"){
      n.mark <- nrow(input)
      threshold <- -log10(sig.level.now / n.mark)
    }
    
    thresholds[thres.no] <- threshold
  }
  names(thresholds) <- paste0(methods, "_", sig.levels)
  return(thresholds)
}


write.table(test.cmh, file = "gwas_50_lo.txt", sep = "\t",
            row.names = FALSE, col.names = FALSE)



