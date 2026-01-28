# ---------------------------------------------------------

# Melbourne Bioinformatics Training Program

# This exercise to assess your familiarity with R and git. Please follow
# the instructions on the README page and link to your repo in your application.
# If you do not link to your repo, your application will be automatically denied.

# Leave all code you used in this R script with comments as appropriate.
# Let us know if you have any questions!


# You can use the resources available on our training website for help:
# Intro to R: https://mbite.org/intro-to-r
# Version Control with Git: https://mbite.org/intro-to-git/

# ----------------------------------------------------------

# Load libraries -------------------
# You may use base R or tidyverse for this exercise
# ex. library(tidyverse)
setwd("/Users/annie/Documents/GitHub/training-program-application-2026")
getwd()
library(tidyverse)
# Load data here ----------------------
# Load each file with a meaningful variable name.
url_seq <- "https://raw.githubusercontent.com/AnnieYan-data/training-program-application-2026/refs/heads/main/data/GSE60450_GeneLevel_Normalized(CPM.and.TMM)_data.csv"
RNA_seq_data <- read.csv(url_seq)
url_metadata <- "https://raw.githubusercontent.com/AnnieYan-data/training-program-application-2026/refs/heads/main/data/GSE60450_filtered_metadata.csv"
meta_data <- read.csv(url_metadata)
# Inspect the data -------------------------
# What are the dimensions of each data set? (How many rows/columns in each?)
# Keep the code here for each file.

## Expression data
nrow(RNA_seq_data)
#23735 rows in expression data
ncol(RNA_seq_data)
#14 columns in expression data

## Metadata
nrow(meta_data)
#12 rows in Metadata
ncol(meta_data)
#4 columns in Metadata

# Prepare/combine the data for plotting ------------------------
# How can you combine this data into one data.frame?
head(RNA_seq_data)
head(meta_data)
colnames(meta_data)[1] <- "sample"
RNA_seq_data <- RNA_seq_data[, -1]
RNA_long <- RNA_seq_data %>%
  pivot_longer(
    cols = -gene_symbol,     
    names_to = "sample",    
    values_to = "expression"  
  )
head(RNA_long)
merged <- RNA_long %>%
  left_join(meta_data, by = "sample")
head(merged)

# Plot the data --------------------------
## Plot the expression by cell type
## Can use boxplot() or geom_boxplot() in ggplot2
gene_to_plot <- "Gnai3"
plot_df <- merged %>% filter(gene_symbol == gene_to_plot)
  
boxplot(
  expression ~ immunophenotype, 
  data = plot_df,
  main = paste(gene_to_plot, "Expression by Cell Type"),
  xlab = "Cell Type",
  ylab = "Expression",
  col = "lightblue"
)
## Save the plot
### Show code for saving the plot with ggsave() or a similar function
if(!dir.exists("results")) dir.create("results")
#  results folder
ggsave(
  filename = paste0("results/", gene, "_expression_by_celltype.png"),
  plot = p,
  width = 6,
  height = 4
)

list.files("results")
