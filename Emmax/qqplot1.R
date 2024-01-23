#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

pvals <- read.table(args[1],header=TRUE)
attach(pvals)
observed <- sort(P)
lobs <- -(log10(observed))
expected <- c(1:length(observed))
lexp <- -(log10(expected / (length(expected)+1)))
#D <-median(CHISQ)/0.455
#print(D)

## Alternative way to compute the genomic control

s <- qchisq(P,1,lower.tail=FALSE)
S <- sort(s)
D1 <-median(S)/0.455
print(D1)

png(args[2], width=624, height=520)
plot(c(0,7), c(0,7), col="red", lwd=3, type="l", xlab="Expected (-logP)", ylab="Observed (-logP)",xlim=c(0,7), ylim=c(0,7), las=1, xaxs="i", yaxs="i", bty="l")
points(lexp, lobs, pch=23, cex=.4, bg="black")
text(2, 5, expression(lambda[GC] == 1.06))
dev.off()
