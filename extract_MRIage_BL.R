library(openxlsx)
library(dplyr)
library(stringr)

# File paths to the key Excel sheets that are needed for the demographics (update these if needed)
subject_ids_path <- "S:/Meg_Stuff/imagen_demographics/subject_ids_common.xlsx"
age_data_path <- "S:/Meg_Stuff/imagen_demographics/age_BL.xlsx"
output_path <- "S:/Meg_Stuff/imagen_demographics/imagen_demographics.xlsx"

# Load subject IDs (assumes ID is in the first column, alter the [1] if it corresponds separately)
subject_ids_df <- read.xlsx(subject_ids_path)
colnames(subject_ids_df)[1] <- "Subject_ID"
subject_ids_df$Subject_ID <- tolower(str_trim(as.character(subject_ids_df$Subject_ID)))

# Load age data (assumes ID is in first column, age in column named "ADNI MPRAGE" - this is because this column has the age at which they got scanned)
age_df <- read.xlsx(age_data_path)
colnames(age_df)[1] <- "Subject_ID"
age_df <- age_df %>%
  select(Subject_ID, Age_BL = `ADNI.MPRAGE`) %>%
  mutate(Subject_ID = tolower(str_trim(as.character(Subject_ID))))

#Merge: only keep Age_BL column
merged_df <- subject_ids_df %>%
  left_join(age_df, by = "Subject_ID")

# Write result to Excel
write.xlsx(merged_df, output_path, rowNames = FALSE)

cat("Excel file 'imagen_demographics.xlsx' created at:", output_path, "\n")
