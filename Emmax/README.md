# GWAS-Genome-Wide-Association-
# Genome-Wide Association Study (GWAS) Analysis with EMMAX

Welcome to the GWAS analysis repository! This project utilizes the EMMAX software to conduct a genome-wide association study, aiming to identify genetic variants associated with 
phenotypic traits of interest.

## Overview
EMMAX is a statistical test for large scale human or model organism association mapping accounting for the sample structure. In addition to the computational efficiency obtained by 
EMMA algorithm, EMMAX takes advantage of the fact that each loci explains only a small fraction of complex traits, which allows us to avoid repetitive variance component estimation 
procedure, resulting in a significant amount of increase in computational time of association mapping using mixed model.

This GWAS analysis involves the following key steps:

# Genome-Wide Association Study (GWAS) Analysis with EMMAX

Welcome to the GWAS analysis repository! This project utilizes the EMMAX software to conduct a genome-wide association study, aiming to identify genetic variants associated with 
phenotypic traits of interest.

## Overview

EMMAX is a statistical test designed for large-scale human or model organism association mapping, accounting for sample structure. It takes advantage of the computational efficiency 
obtained by the EMMA algorithm and exploits the fact that each locus explains only a small fraction of complex traits. This unique feature allows EMMAX to avoid repetitive variance 
component estimation procedures, resulting in a significant increase in computational efficiency for association mapping using mixed models.

This GWAS analysis involves the following key steps:

1. **Preparing Input Genotype Files:**
   - Ensure your genotype data is in PLINK format (bed, bim, fam).
   - Apply a call rate threshold of 95% and a Minor Allele Frequency (MAF) threshold of 0.01 when preparing the data.
   - If conducting case-control analysis, encode case/control to 2/1.

2. **Transposing Genotype Files:**
   - Use PLINK software to transpose your genotype files (bed or ped format) to tped/tfam format:
     ```bash
     plink --bfile file --recode12 --output-missing-genotype 0 --transpose --out files
     ```

3. **Creating Marker-Based Kinship Matrix:**
   - Create a kinship matrix (IBS or BN) using emmax-kin:
     - IBS matrix:
       ```bash
       emmax-kin-intel64 -v -s -d 10 files
       ```
     - BN (Balding-Nichols) matrix:
       ```bash
       emmax-kin-intel64 -v -d 10 files
       ```
     - This will generate kinship files: `files.aIBS.kinf` and `files.aBN.kinf`.

4. **Run EMMAX Association:**
   - Run EMMAX with the phenotype, tped/tfam files, and the kinship files:
     ```bash
     emmax -v -d 10 -t files -p [pheno_file] -k files -o result
     ```
     - This will generate files: `resulte.reml` and `results.ps`.

   - The `results.reml` file contains REML output with log-likelihoods, variance components, and pseudo-heritability estimates.

   - The `results.ps` file contains SNP information, including SNP ID, Beta, Standard Error (SE), and p-value.

5. ** Convert emmax result to plink format
   - Generate QQplot and Manhattan plot

