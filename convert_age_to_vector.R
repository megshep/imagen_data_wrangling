ages <- read.csv("vector_imputed_ages_years.csv")

# Compute times relative to baseline
rel_times <- ages
rel_times$Age_FU2 <- rel_times$Age_FU2 - rel_times$Age_BL
rel_times$Age_FU3 <- rel_times$Age_FU3 - rel_times$Age_BL
rel_times$Age_BL <- 0

# Optional: save as a long format for MATLAB if needed
# Or just keep wide format with baseline, FU2, FU3
write.csv(rel_times, "vector_relative_times_years.csv", row.names = FALSE)
