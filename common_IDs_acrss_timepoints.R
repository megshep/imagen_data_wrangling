library(openxlsx)

# Paths to the 3 Excel files (this instance its an excel file for each timepoint of my analysis)
file1 <- "S:/Meg_Stuff/BL_nifti/subject_ids_BL_unique_p2.xlsx"
file2 <- "S:/Meg_Stuff/FU2_nifti/subject_ids_FU2_unique_p2.xlsx"
file3 <- "S:/Meg_Stuff/FU3_nifti/subject_ids_FU3_unique_p2.xlsx"

# Read all three Excel sheets (assuming they all have a column called "Subject_ID" - this needs to be checked beforehand or it will fail!)
ids1 <- read.xlsx(file1)$Subject_ID
ids2 <- read.xlsx(file2)$Subject_ID
ids3 <- read.xlsx(file3)$Subject_ID

# Find common IDs across all three Excel sheets
common_ids <- Reduce(intersect, list(ids1, ids2, ids3))

# Create a data frame of the overlapping IDs
common_df <- data.frame(Common_Subject_IDs = common_ids)

# Save to a new Excel file
output_file <- "S:/Meg_Stuff/subject_ids_common_p2.xlsx"
write.xlsx(common_df, output_file, rowNames = FALSE)

#Done
cat("Common IDs saved to:", output_file, "\n")
