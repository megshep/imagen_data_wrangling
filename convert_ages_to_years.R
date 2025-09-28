#read the csv file that has the age data (for my LVBM this has to be converted into years first)
ages <- read.csv("vector_imputed_ages.csv", stringsAsFactors = FALSE)

# Check the data
head(ages)

# Convert ages from days -> years
# Assume columns are named: Age_BL, Age_FU2, Age_FU3 (change these if not)
ages$Age_BL <- ages$Age_BL / 365.25
ages$Age_FU2      <- ages$Age_FU2 / 365.25
ages$Age_FU3      <- ages$Age_FU3 / 365.25


# Write to a new CSV - this is ready to be uploaded to the CSF to be used in the model (and referred to in the .m script)
write.csv(ages, "vector_imputed_ages_years.csv", row.names = FALSE)
