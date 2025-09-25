# Load required packages
library(openxlsx)

# Paths to your 3 Excel files
file1 <- "S:/Meg_Stuff/BL_nifti/subject_ids_BL_unique.xlsx"
file2 <- "S:/Meg_Stuff/FU2_nifti/subject_ids_FU2_unique.xlsx"
file3 <- "S:/Meg_Stuff/FU3_nifti/subject_ids_FU3_unique.xlsx"

# Read all three Excel sheets (assuming they all have a column called "Subject_ID")
ids1 <- read.xlsx(file1)$Subject_ID
ids2 <- read.xlsx(file2)$Subject_ID
ids3 <- read.xlsx(file3)$Subject_ID

# Find IDs that are not in all three lists (i.e., discrepancies)
only_in_file1 <- setdiff(ids1, union(ids2, ids3))  # IDs only in file1
only_in_file2 <- setdiff(ids2, union(ids1, ids3))  # IDs only in file2
only_in_file3 <- setdiff(ids3, union(ids1, ids2))  # IDs only in file3

# Find IDs that are in two lists but not in the third
in_both_file1_file2 <- setdiff(intersect(ids1, ids2), ids3)
in_both_file1_file3 <- setdiff(intersect(ids1, ids3), ids2)
in_both_file2_file3 <- setdiff(intersect(ids2, ids3), ids1)

#Combine all discrepancies into one data frame
discrepancies <- data.frame(
  Only_in_File1 = c(only_in_file1, rep(NA, length(only_in_file2) + length(only_in_file3) + length(in_both_file1_file2) + length(in_both_file1_file3) + length(in_both_file2_file3))),
  Only_in_File2 = c(rep(NA, length(only_in_file1)), only_in_file2, rep(NA, length(only_in_file3) + length(in_both_file1_file2) + length(in_both_file1_file3) + length(in_both_file2_file3))),
  Only_in_File3 = c(rep(NA, length(only_in_file1) + length(only_in_file2)), only_in_file3, rep(NA, length(in_both_file1_file2) + length(in_both_file1_file3) + length(in_both_file2_file3))),
  In_Both_File1_File2_Not_File3 = c(rep(NA, length(only_in_file1) + length(only_in_file2) + length(only_in_file3)), in_both_file1_file2, rep(NA, length(in_both_file1_file3) + length(in_both_file2_file3))),
  In_Both_File1_File3_Not_File2 = c(rep(NA, length(only_in_file1) + length(only_in_file2) + length(only_in_file3) + length(in_both_file1_file2)), in_both_file1_file3, rep(NA, length(in_both_file2_file3))),
  In_Both_File2_File3_Not_File1 = c(rep(NA, length(only_in_file1) + length(only_in_file2) + length(only_in_file3) + length(in_both_file1_file2) + length(in_both_file1_file3)), in_both_file2_file3)
)

#Save the discrepancies to a new Excel file
output_file <- "S:/Meg_Stuff/subject_ids_discrepancies_p2.xlsx"
write.xlsx(discrepancies, output_file, rowNames = FALSE)

#Done
cat("Discrepancies saved to:", output_file, "\n")
