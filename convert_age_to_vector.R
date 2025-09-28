#Read in the csv file that has the ages calculated and converted into years
ages <- read.csv("vector_imputed_ages_years.csv")

# Compute times relative to baseline (how far away from baseline are the two follow-up scans for each participant?)
rel_times <- ages
rel_times$Age_FU2 <- rel_times$Age_FU2 - rel_times$Age_BL
rel_times$Age_FU3 <- rel_times$Age_FU3 - rel_times$Age_BL
rel_times$Age_BL <- 0


# save as a .csv file with the vector information ready to be input into the model
write.csv(rel_times, "vector_relative_times_years.csv", row.names = FALSE)
