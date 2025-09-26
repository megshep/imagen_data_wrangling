# Load required packages
library(openxlsx)

# Paths to your 3 Excel files
file1 <- "S:/Meg_Stuff/BL_nifti/subject_ids_BL_unique_p2.xlsx"
file2 <- "S:/Meg_Stuff/FU2_nifti/subject_ids_FU2_unique_p2.xlsx"
file3 <- "S:/Meg_Stuff/FU3_nifti/subject_ids_FU3_unique_p2.xlsx"

# Read all three Excel sheets (assuming they all have a column called "Subject_ID")
ids1 <- read.xlsx(file1)$Subject_ID
ids2 <- read.xlsx(file2)$Subject_ID
ids3 <- read.xlsx(file3)$Subject_ID

# Find common IDs across all three
common_ids <- Reduce(intersect, list(ids1, ids2, ids3))

# Create a data frame of the overlapping IDs
common_df <- data.frame(Common_Subject_IDs = common_ids)

# Save to a new Excel file
output_file <- "S:/Meg_Stuff/subject_ids_common_p2.xlsx"
write.xlsx(common_df, output_file, rowNames = FALSE)

#Done
cat("Common IDs saved to:", output_file, "\n")
