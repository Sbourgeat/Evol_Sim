setwd("~/Documents/DGRP_simulation/Replicate_runs_morerep")

library(DescTools)
library(ROCR)


s1 <- read.table("score_90", quote="\"", comment.char="")
s2 <- read.table("score_90_more", quote="\"", comment.char="")

s2 <- read.table("score_80", quote="\"", comment.char="")
s3 <- read.table("score_70", quote="\"", comment.char="")
s4 <- read.table("score_60", quote="\"", comment.char="")
s5 <- read.table("score_50", quote="\"", comment.char="")


l1 <- read.table("90_labels", quote="\"", comment.char="")
l2 <- read.table("90_more_labels", quote="\"", comment.char="")

l2 <- read.table("80_labels", quote="\"", comment.char="")
l3 <- read.table("70_labels", quote="\"", comment.char="")
l4 <- read.table("60_labels", quote="\"", comment.char="")
l5 <- read.table("50_labels", quote="\"", comment.char="")

pl1 <- read.table("90_predictions", quote="\"", comment.char="")
pl2 <- read.table("90_more_predictions", quote="\"", comment.char="")


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


#group = c('10%','10%','10%','10%','10%','10%','10%','10%','10%','10%','20%','20%','20%','20%','20%','20%','20%','20%','20%','20%','30%','30%','30%','30%','30%','30%','30%','30%','30%','30%','40%','40%','40%','40%','40%','40%','40%','40%','40%','40%','50%','50%','50%','50%','50%','50%','50%','50%','50%','50%')


#y = c(auc1,auc2,auc3,auc4,auc5)
y = c(auc1,auc2)

#group = c('90%','90%','90%','90%','90%','90%','90%','90%','90%','90%','80%','80%','80%','80%','80%','80%','80%','80%','80%','80%','70%','70%','70%','70%','70%','70%','70%','70%','70%','70%','60%','60%','60%','60%','60%','60%','60%','60%','60%','60%','50%','50%','50%','50%','50%','50%','50%','50%','50%','50%')
#group = c('10%','10%','10%','10%','10%','10%','10%','10%','10%','10%','20%','20%','20%','20%','20%','20%','20%','20%','20%','20%','30%','30%','30%','30%','30%','30%','30%','30%','30%','30%','40%','40%','40%','40%','40%','40%','40%','40%','40%','40%','50%','50%','50%','50%','50%','50%','50%','50%','50%','50%')
group = c('10 Replicates','10 Replicates','10 Replicates','10 Replicates','10 Replicates','10 Replicates','10 Replicates','10 Replicates','10 Replicates','10 Replicates','20 Replicates','20 Replicates','20 Replicates','20 Replicates','20 Replicates','20 Replicates','20 Replicates','20 Replicates','20 Replicates','20 Replicates')
data = data.frame(y = y, group = factor(group))


#my_comparisons = list( c("90%", "80%"), c("90%", "70%"), c("90%", "60%"),c("90%", "50%") )
my_comparisons = list( c("10%", "20%"), c("10%", "30%"), c("10%", "40%"),c("10%", "50%") )




library(tidyverse)
library(rstatix)   
library(ggpubr)


stat.test <- compare_means(
  y ~ group, data = data,
  method = "wilcox.test",
  ref.group = '10%'
)
stat.test



stat.test

p <- ggline(data, x = "group", y = "y", color = "group", legend="none",
       add = c("mean_se","jitter"), 
       #order = c('10%','20%','30%','40%','50%'),
       ylab = "pAURC", xlab = "Number of replicates")+
  #stat_compare_means(comparisons = my_comparisons,label = 'p.adj')+ # Add pairwise comparisons p-value
  stat_compare_means(label.y = 0.001275) 
  #stat_compare_means(label.y = 0.008)

  #geom_hline(yintercept = mean(auc1), linetype = 2)
 # stat_pvalue_manual(stat.test, label = "p.adj.signif")

#stat.test <- stat.test %>% add_xy_position(x = "group")

#stat.test <- stat.test %>% #add_xy_position(x = "group", dodge = 0.9)
  #mutate(y.position = c(29, 35, 39))
#p + stat_pvalue_manual(stat.test, label = "p.signif")
p

stat.test <- stat.test %>%
  mutate(y.position = c(0.0105,0.011,0.0115,0.012))
p + stat_pvalue_manual(stat.test, label = "p = {p.adj}",tip.length = .01)








S1 = unlist(s1)
S2 = unlist(s2)
S3 = unlist(s3)
S4 = unlist(s4)
S5 = unlist(s5)



Y = c(S1,S2,S3,S4,S5)
Y = c(S1,S2)

#group = c('90%','90%','90%','90%','90%','90%','90%','90%','90%','90%','80%','80%','80%','80%','80%','80%','80%','80%','80%','80%','70%','70%','70%','70%','70%','70%','70%','70%','70%','70%','60%','60%','60%','60%','60%','60%','60%','60%','60%','60%','50%','50%','50%','50%','50%','50%','50%','50%','50%','50%')
#group = c('10%','10%','10%','10%','10%','10%','10%','10%','10%','10%','20%','20%','20%','20%','20%','20%','20%','20%','20%','20%','30%','30%','30%','30%','30%','30%','30%','30%','30%','30%','40%','40%','40%','40%','40%','40%','40%','40%','40%','40%','50%','50%','50%','50%','50%','50%','50%','50%','50%','50%')

data = data.frame(y = Y, group = factor(group))


#my_comparisons = list( c("90%", "80%"), c("90%", "70%"), c("90%", "60%"),c("90%", "50%") )
my_comparisons = list( c("10%", "20%"), c("10%", "30%"), c("10%", "40%"),c("10%", "50%") )


stat.test <- compare_means(
  y ~ group, data = data,
  method = "wilcox.test",
  ref.group = '10%'
)
stat.test



stat.test

p <- ggline(data, x = "group", y = "y", color = "group", legend="none",
            add = c("mean_se","jitter"), 
            #order = c('10%','20%','30%','40%','50%'),
            ylab = "Efficiency score", xlab = "Selective pressure")+
  #stat_compare_means(comparisons = my_comparisons,label = 'p.adj')+ # Add pairwise comparisons p-value
  stat_compare_means(label.y = 0.0034) 
#stat_compare_means(label.y = 0.008)

#geom_hline(yintercept = mean(auc1), linetype = 2)
# stat_pvalue_manual(stat.test, label = "p.adj.signif")

#stat.test <- stat.test %>% add_xy_position(x = "group")

#stat.test <- stat.test %>% #add_xy_position(x = "group", dodge = 0.9)
#mutate(y.position = c(29, 35, 39))
#p + stat_pvalue_manual(stat.test, label = "p.signif")
p

stat.test <- stat.test %>%
  mutate(y.position = c(0.0026,0.0028,0.0030,0.0032))
p + stat_pvalue_manual(stat.test, label = "p = {p.adj}",tip.length = .01)






     


test12 = wilcox.test(auc1, auc2)
print(test12)

test13 = wilcox.test(auc1, auc3)
print(test13)

test14 = wilcox.test(auc1, auc4)
print(test14)

test15 = wilcox.test(auc1, auc5)
print(test15)


### Test boxplots with t-test

t12 = t.test(s1,s2)
print(t12)

t13 = t.test(s1,s3)
print(t13)

t14 = t.test(s1,s4)
print(t14)

t15 = t.test(s1,s5)
print(t15)


t23 = t.test(s2,s3)
print(t23)

t24 = t.test(s2,s4)
print(t24)

t25 = t.test(s2,s5)
print(t25)

t43 = t.test(s4,s3)
print(t43)

t45 = t.test(s4,s5)
print(t45)

t53 = t.test(s5,s3)
print(t53)

#### Normality of data
### The data follows a normal distribution
S1 = unlist(s1)
S2 = unlist(s2)
S3 = unlist(s3)
S4 = unlist(s4)
S5 = unlist(s5)
shapiro.test(S1)
shapiro.test(S2)
shapiro.test(S3)
shapiro.test(S4)
shapiro.test(S5)


library(ggpubr)
#ggqqplot(S1)
#ggqqplot(S2)
#ggqqplot(S3)
#ggqqplot(S4)
#ggqqplot(S5)


###Homoscedasticity
###The variances in each of the groups (samples) are the same.
C = c(s1,s2,s3,s4,s5)
bartlett.test(C)



### ANOVA
y = c(S1,S2,S3,S4,S5)
n = rep(10, 5)
group = rep(1:5, n)
tmp = tapply(y, group, stem)
stem(y)

tmpfn = function(x) c(sum = sum(x), mean = mean(x), var = var(x), n = length(x))

tapply(y, group, tmpfn)
data = data.frame(y = y, group = factor(group))
fit = lm(y ~ group, data)
anova(fit)
# Compute the analysis of variance
res.aov <- aov(y ~ group, data = data)
# Summary of the analysis
summary(res.aov)
TukeyHSD(res.aov)


library("ggpubr")
ggline(data, x = "group", y = "y", 
       add = c("mean_se", "jitter"), 
       order = c("1", "2", "3",'4','5'),
       ylab = "Efficiency score", xlab = "Selection regime")


# Kruskal test

kruskal.test(y ~ group, data = data)

pairwise.wilcox.test(data$y, data$group,
                     p.adjust.method = "BH")






######################################


library('rlist')
S = score_traj[-c(1),]
s1 = S['V2']
s2 = S['V3']
s3 = S['V4']
#y = c(auc1,auc2,auc3,auc4,auc5)
y = c(s3,s2,s1)

S1 = c()
for(i in s1){
  S1 = list.append(S1,i)
}
S1 = as.numeric(S1)


S2 = c()
for(i in s2){
  S2 = list.append(S2,i)
}
S2 = as.numeric(S2)

S3 = c()
for(i in s3){
  S3 = list.append(S3,i)
}
S3= as.numeric(S3)



#group = c('90%','90%','90%','90%','90%','90%','90%','90%','90%','90%','80%','80%','80%','80%','80%','80%','80%','80%','80%','80%','70%','70%','70%','70%','70%','70%','70%','70%','70%','70%','60%','60%','60%','60%','60%','60%','60%','60%','60%','60%','50%','50%','50%','50%','50%','50%','50%','50%','50%','50%')
#group = c('10%','10%','10%','10%','10%','10%','10%','10%','10%','10%','20%','20%','20%','20%','20%','20%','20%','20%','20%','20%','30%','30%','30%','30%','30%','30%','30%','30%','30%','30%','40%','40%','40%','40%','40%','40%','40%','40%','40%','40%','50%','50%','50%','50%','50%','50%','50%','50%','50%','50%')
l = c('G100')
li = c('G300')
lii = c('G500')
for(i in 1:49){
  l=list.append(l,'G100')
  li=list.append(li,'G300')
  lii=list.append(lii,'G500')
}

group = c(l,li,lii)

y = c(S3,S2,S1)



data = data.frame(y = y, group = factor(group))








library(tidyverse)
library(rstatix)   
library(ggpubr)


stat.test <- compare_means(
  y ~ group, data = data,
  method = "wilcox.test",
  #ref.group = '10%'
)
stat.test



stat.test

p <- ggline(data, x = "group", y = "y", color = "group", legend="none",
            add = c("mean_se","jitter"), 
            #order = c('10%','20%','30%','40%','50%'),
            ylab = "Effect sizes", xlab = "Number of generations")+
  #stat_compare_means(comparisons = my_comparisons,label = 'p.adj')+ # Add pairwise comparisons p-value
  stat_compare_means() 
#stat_compare_means(label.y = 0.008)

#geom_hline(yintercept = mean(auc1), linetype = 2)
# stat_pvalue_manual(stat.test, label = "p.adj.signif")

#stat.test <- stat.test %>% add_xy_position(x = "group")

#stat.test <- stat.test %>% #add_xy_position(x = "group", dodge = 0.9)
#mutate(y.position = c(29, 35, 39))
#p + stat_pvalue_manual(stat.test, label = "p.signif")
p

stat.test <- stat.test %>%
  mutate(y.position = c(4,4.5,5))
p + stat_pvalue_manual(stat.test, label = "p = {p.adj}",tip.length = .01)

ggdensity(data, x = "y", y = '..density..', color = "group", add = 'mean', rug = TRUE,xlab = 'Effect size')
       




















################### TEST WITH MULTIGRID PLOT########################################"
library(readxl)
pAUC_all <- read.csv("~/Desktop/pAUC_all.csv")
View(pAUC_all)  

ggline(
  pAUC_all, x = "group", y = "y" ,color = "group", ylab = "score", xlab = "Selective pressure",
  add = c("mean_sd", "jitter"), facet =c("score","scenario"), scales="free" 
  ) #+
  #theme(axis.text.x = element_text(size=11))

# +

  #stat_compare_means() 


#########"

library(readxl)
more_rep <- read.csv("~/Desktop/more_rep.csv")

more_rep$now = factor(more_rep$Score, levels=c('pAURC','Efficiency score'))

p <- ggline(
  more_rep, x = "Replicates", y = "y" ,color = "Replicates", ylab = "score", xlab = "Replicates number",
  add = c("mean_se","jitter"), facet =c("now"), scales="free" ,las=2) + 
  theme(axis.text.x = element_text(size=11,), axis.text.y=element_text(size=11),
        axis.title.x = element_text(size=12), 
        axis.title.y=element_text(size=12),legend.position="bottom",strip.text.x = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.15)))+
  stat_compare_means() 
  

p

##################


pAUC_nor <- read.csv("~/Desktop/pAUC_normalized.csv")
View(pAUC_all)  


pAUC_nor$now = factor(pAUC_nor$scenario, levels=c('1000 SNPs','500 SNPs','100 SNPs','50 SNPs','10 SNPs'))
pAUC_nor$score = factor(pAUC_nor$score, levels=c('pAURC','Efficiency score'))

pAUC_all$now = factor(pAUC_nor$scenario, levels=c('1000 SNPs','500 SNPs','100 SNPs','50 SNPs','10 SNPs'))
pAUC_all$score = factor(pAUC_all$score, levels=c('pAURC','Efficiency score'))


stat.test <- compare_means(
  y ~ group, data = pAUC_all,
  method = "wilcox.test",
  group.by = c("score","now"),
  ref.group = '10%'
)
stat.test


stat.test <- pAUC_all %>%
  group_by(score,now) %>%
  wilcox_test(y ~ group, ref.group = "10%") %>%
  adjust_pvalue(method = "BH")
stat.test





p <- ggline(
  pAUC_nor, x = "group", y = "y" ,color = "group", ylab = "Normalized score", xlab = "Selective pressure",
  add = c("mean_se","jitter"), facet =c("score","now"), scales="free" ,las=2) + 
  theme(axis.text.x = element_text(angle = 45, vjust = 0.8, size=11,), axis.text.y=element_text(angle = 45, vjust = 0.5, size=11),
        axis.title.x = element_text(size=12), 
          axis.title.y=element_text(size=12),legend.position="bottom",strip.text.x = element_text(size = 12),
          strip.text.y = element_text(size = 12)) #+
  #ylim(0,1.3)+
  #grids(linetype = "dashed")+

 #theme_cleveland() +
  #stat_compare_means(hjust = 0.1 , size = 2.3,label.y = 1.15)

stat.test <- stat.test %>% add_xy_position(x="group", fun = "mean_sd", dodge = 0.8)
stat.test <- stat.test %>% add_y_position(fun = "mean_sd")


stat.test <- stat.test %>% mutate(y.position = dc)

p + stat_pvalue_manual(stat.test, hide.ns = TRUE, label = "p.adj.signif") +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.15)))


dc = c()
x = 1
for(ii in 1:10){
  for(i in 1:4){
    xx = x + (0.1*i-1)
    dc = list.append(dc,xx)
}}

dc =dc+1
dc






#############################

library(rlist)
roc = c()
rocy = c()


roc=list.append(roc,xxx)
rocy=list.append(rocy,xxx)

#########################

y=c(0.049694235170703795,0, 0.0031344744387527615,1/12)
x = c("Polygenic", "Polygenic", "Oligogenic", "Oligogenic")
score = c("E&R","GWAS","E&R","GWAS")
data = data.frame(y = y, group = factor(x))
data$type = score
data

data$now = factor(data$group, levels=c("Polygenic", "Oligogenic"))



ggbarplot(
  data, x = "type", y = "y" ,color = "type", ylab = "score", xlab = "Study type",
  add = c("mean_sd", "jitter"), facet =c("now"), scales="free" 
) +
  theme(axis.text.x = element_text(size=11,), axis.text.y=element_text(size=11),
        axis.title.x = element_text(size=12), 
        axis.title.y=element_text(size=12),legend.position="bottom",strip.text.x = element_text(size = 12),
        strip.text.y = element_text(size = 12)) 
