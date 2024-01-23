#!/usr/bin/env Rscript

m1 <- read.table("Meta1.txt", h=T)
m2 <- read.table("Meta2.txt", h=T)
colnames(m2) <- c("SNP","Allele1","Allele2","Freq.Allele1","P2","N")
m <- merge(m1, m2, by = "SNP")
write.table(m, "MetaMerged.txt", col.names=T, row.names=F, quote=F, sep="\t")
View(m)
