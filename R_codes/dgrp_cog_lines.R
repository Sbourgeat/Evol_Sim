# Import Data

library(readxl)
DGRP_freeze_lines <- read_excel("Documents/DGRP_simulation/Data/DGRP_freeze_lines.xlsx")


# Determine the position of the lines we want to study

det_pos <- function(table){
  
  freeze <- table[,1]
  cog <- table[,2]
  
  pos <- list()
  line <- list()
  
  for(i in 1:length(cog[[1]])){
    if(!(is.na(cog[[1]][i]))){
      line<-append(line,cog[[1]][i])
      for(y in 1:length(freeze[[1]])){
       #print('Hola!',freeze[[1]][y],cog[[1]][i])
       if(freeze[[1]][y] == cog[[1]][i]){
         pos<-append(pos,y)
         #print(y)
        }
      }
    }
  }
  
  DF <- do.call(rbind, Map(data.frame, Line=line, Pos=pos))
  return(DF)
}



DF <- det_pos(DGRP_freeze_lines)


# Export the data

write.table(DF, file = "Documents/DGRP_simulation/Data/dgrp_lines_cognitive.txt", sep = "\t",
            row.names = FALSE, col.names = TRUE)





# Extract from haplotype file the correct lines

## import haplotype file
dgrp <- read.table("~/Documents/DGRP_simulation/Data/dgrp.mimhap", quote="\"", comment.char="")


truncate_data <- function(dgrp_hap,lines){
  new_dgrp <- dgrp_hap['V1']
  
  DF$linename <- paste0("'", DF$Line,"'")
}


n <-list()
#extract the positions
for(i in 1:length(DF$Pos)){ n<- append(n,c(DF$Pos[i])) }
n<- unlist(n, use.names=TRUE)
n <- n+4
#create the new data set
new_dgrp <- dgrp[,c(1:4,n)]

#save the new dataset

write.table(new_dgrp, file = "~/Documents/DGRP_simulation/Data/cognitive_lines.mimhap", sep = "\t",
            row.names = FALSE, col.names = FALSE, quote = FALSE, fileEncoding = 'UTF-8')


########################################################
# Create a new data set for each DGRP lines to be used #
########################################################

create_new_data <- function(data, pos){
  name <- data[,c(1:4,pos+4)]
  return(name)
}


for(i in 1:length(DF$Pos)){
  new_df <- create_new_data(dgrp,DF$Pos[i])
  file_name <- paste0("Documents/DGRP_simulation/Data",DF$Line[i], ".mimhap")
  write.table(new_df, file = file_name, sep = "\t",
              row.names = FALSE, col.names = FALSE, quote = FALSE)
}



#### Adjust popsize in haplotype file

pop.size <- function(data,popsize){
  new.df = cbind(data, replicate(popsize,data$V5))
  file_name <- paste0("Documents/DGRP_simulation/Data/DGRP_lines/",deparse(substitute(data)),popsize, ".mimhap")
  write.table(new.df, file = file_name, sep = "\t",
              row.names = FALSE, col.names = FALSE, quote = FALSE, fileEncoding = "UTF-8")
}





  
  
  