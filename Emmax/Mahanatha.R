#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(qqman)
library(knitr)
#opts_chunk$set(comment=NA, fig.width=12, fig.height=9, message=FALSE, tidy=TRUE, dpi=75)

png(args[2], width = 780, height = 480)  

gwasResults <- read.table(args[1],header=T)
manhattan(gwasResults, ylim=c(0,11), cex=0.6, cex.axis=0.5, col=c("blue4", "orange3"), suggestiveline=3.3, genomewideline=-log10(5.10e-08), chrlabs=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22"))
dev.off()
