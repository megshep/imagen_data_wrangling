ages <- read.csv("vector_imputed_ages.csv", stringsAsFactors = FALSE)

# Check the data
head(ages)

# Convert ages from days -> years
# Assume columns are named: Baseline, FU2, FU3
ages$Age_BL <- ages$Age_BL / 365.25
ages$Age_FU2      <- ages$Age_FU2 / 365.25
ages$Age_FU3      <- ages$Age_FU3 / 365.25

# Optional: check result
head(ages)

# Write back to a new CSV
write.csv(ages, "vector_imputed_ages_years.csv", row.names = FALSE)
