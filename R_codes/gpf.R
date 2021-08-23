#import data

gpf <- read.delim("~/Documents/DGRP_simulation/variable_environment/gpf", header=FALSE)

#rename the columns
names(gpf)[1] <- "replicate"
names(gpf)[2] <- "generation"
names(gpf)[3] <- "sex"
names(gpf)[4] <- "genotype"
names(gpf)[5] <- "phenotype"
names(gpf)[6] <- "fitness"


# Libraries
library(ggplot2)
library(hrbrthemes)
library(dplyr)
library(tidyr)
library(viridis)

# The diamonds dataset is natively available with R.

# Without transparency (left)
p1 <- ggplot(data=gpf, aes(x=phenotype, group=generation, fill=generation)) +
  geom_density(adjust=1.5) +
  theme_ipsum()
p1

# With transparency (right)
p2 <- ggplot(data=gpf, aes(x=phenotype, group=generation, fill=generation)) +
  geom_density(adjust=1.5, alpha=.4) +
  theme_ipsum()
p2

