### GWAS-Genome-Wide-Association

GWAS stands for Genome-Wide Association Study. It is a type of study in genetics that aims to identify genetic variations associated with particular traits or diseases across the entire genome. The human genome consists of a vast number of DNA sequences, and variations in these sequences can influence an individual's susceptibility to diseases, response to treatments, or other traits.

Here's an overview of GWAS and its significance:

1. **Purpose of GWAS:**
   - **Identifying Genetic Variants:** GWAS is conducted to identify single nucleotide polymorphisms (SNPs) and other genetic variations that are associated with specific traits or diseases.
   - **Understanding Disease Etiology:** By identifying genetic markers associated with diseases, researchers can gain insights into the genetic basis of various conditions.
   - **Predicting Disease Risk:** GWAS results can be used to assess an individual's genetic predisposition to certain diseases, providing information about their potential risk.

2. **Why Use GWAS:**
   - **Genetic Basis Exploration:** GWAS helps researchers uncover the genetic factors that contribute to the development of diseases or influence certain traits.
   - **Precision Medicine:** Understanding the genetic basis of diseases allows for more personalized and targeted medical treatments, known as precision medicine.
   - **Drug Development:** Identifying genetic markers associated with diseases can aid in the development of new drugs or therapies that specifically target those markers.

3. **Impact in Clinical Medicine:**
   - **Disease Risk Prediction:** GWAS results can be utilized in clinical settings to predict an individual's risk of developing certain diseases, enabling proactive healthcare strategies.
   - **Treatment Personalization:** In precision medicine, genetic information from GWAS can be used to tailor medical treatments based on an individual's genetic profile.
   - **Early Detection:** Genetic markers identified through GWAS can sometimes be indicative of disease risk even before symptoms manifest, allowing for early detection and intervention.

4. **Role of Bioinformatics in GWAS:**
   - **Data Analysis:** GWAS involves analyzing large datasets of genetic information. Bioinformatics tools and algorithms are crucial for processing, analyzing, and interpreting these vast amounts of genetic data.
   - **Variant Annotation:** Bioinformatics helps annotate and interpret the functional significance of genetic variants identified in GWAS. Understanding how these variants affect genes and biological pathways is essential.
   - **Integration with other Data Types:** Bioinformatics facilitates the integration of genetic data with other omics data (e.g., transcriptomics, proteomics) to gain a comprehensive understanding of the molecular mechanisms underlying diseases.

## QC Steps before GWAS Analysis ##
To ensure the reliability and accuracy of GWAS results, it is crucial to perform thorough quality control (QC) on the data. QC steps are designed to remove potential confounding factors such as missing data, relatedness, and population stratification that could bias the results. This guide provides a step-by-step protocol for conducting GWAS QC and performing association analysis using EMMAX, a tool that accounts for population structure and relatedness.
Purpose

The primary purpose of GWAS QC is to clean the dataset by:

    Filtering out samples and variants with high missingness: Ensures that the data used for analysis is complete and reliable.
    Identifying and removing related individuals: Prevents confounding due to familial relationships.
    Merging with reference datasets (HapMap): Allows for the identification and adjustment of population stratification.

Once the QC steps are completed, the clean dataset is ready for GWAS using EMMAX, which helps to identify genetic variants associated with the trait of interest while controlling for population structure and relatedness.
Step-by-Step Instructions
## 1. Missingness Filtering

Objective: Remove samples and variants with a high proportion of missing data.

Script: 01MissingnessFiltering

Commands:

bash

### Filter individuals with high missingness
´plink --bfile input_data --mind 0.02 --make-bed --out data_mind

### Filter SNPs with high missingness
plink --bfile data_mind --geno 0.02 --make-bed --out data_geno

Output: data_geno.bed, data_geno.bim, data_geno.fam
## 2. Relatedness Filtering

Objective: Identify and remove related individuals to avoid confounding due to population structure.

Script: 02RelatednessFiltering

Commands:

bash

### Calculate pairwise identity by descent (IBD)
plink --bfile data_geno --genome --min 0.185 --out data_ibd

### Extract pairs of related individuals
awk '$10 > 0.185' data_ibd.genome > related_pairs.txt

### Remove one individual from each related pair
plink --bfile data_geno --missing --out data_miss

# Create a list of individuals to remove
python relatedness_filter.py data_ibd.genome data_miss.imiss related_individuals_to_remove.txt

# Remove related individuals
plink --bfile data_geno --remove related_individuals_to_remove.txt --make-bed --out data_related_filtered

Output: data_related_filtered.bed, data_related_filtered.bim, data_related_filtered.fam
## 3. Merging Datasets

Objective: Merge the cleaned dataset with HapMap data for population stratification analysis.

Script: 03MergeHapMap

Commands:

bash

### Merge with HapMap data
plink --bfile data_related_filtered --bmerge hapmap_data.bed hapmap_data.bim hapmap_data.fam --make-bed --out merged_data

### Handle any SNP mismatches
plink --bfile data_related_filtered --exclude merged_data-merge.missnp --make-bed --out data_cleaned
plink --bfile hapmap_data --exclude merged_data-merge.missnp --make-bed --out hapmap_cleaned

### Merge cleaned datasets
plink --bfile data_cleaned --bmerge hapmap_cleaned.bed hapmap_cleaned.bim hapmap_cleaned.fam --make-bed --out merged_data_cleaned

Output: merged_data_cleaned.bed, merged_data_cleaned.bim, merged_data_cleaned.fam
## 4. Performing GWAS with EMMAX

Objective: Conduct genome-wide association study using EMMAX to account for population structure and relatedness.

Commands:

bash

# Generate kinship matrix
emmax-kin -v -h merged_data_cleaned

# Perform association testing
emmax -v -d 10 -t merged_data_cleaned -p phenotype.txt -k merged_data_cleaned.hIBS.kinf -o gwas_results

Output: gwas_results.ps
Final Notes

    Ensure that all paths to input files are correctly specified in each command.
    The quality of the GWAS results depends heavily on the thoroughness of the QC steps.
    Interpret the GWAS results in the context of the population and the study design.

In summary, GWAS is a powerful tool that has revolutionized our understanding of the genetic basis of diseases. Its impact on clinical medicine lies in the potential for personalized treatments, early detection, and improved disease risk prediction. Bioinformatics plays a crucial role in handling the massive amount of genetic data generated by GWAS and extracting meaningful insights from it.

## Authors

- [Etienne Ntumba](https://github.com/EtienneNtumba) 
