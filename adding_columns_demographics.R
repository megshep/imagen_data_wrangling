# Load libraries
library(openxlsx)
library(dplyr)
library(stringr)

# --- File paths
demographics_path <- "S:/Meg_Stuff/imagen_demographics/imagen_demographics.xlsx"
sex_rec_path <- "S:/Meg_Stuff/imagen_demographics/IMAGEN_sex_recruitment_centre.xlsx"

# --- Load the existing demographics sheet
demographics_df <- read.xlsx(demographics_path)
colnames(demographics_df)[1] <- "Subject_ID"  # Standardize column name
demographics_df$Subject_ID <- tolower(str_trim(as.character(demographics_df$Subject_ID)))

# --- Load FU2 age data
sex_rec_df <- read.xlsx(sex_rec_path)
colnames(sex_rec_df)[1] <- "Subject_ID"
sex_rec_df <- sex_rec_df %>%
  select(Subject_ID, Recruitment_Centre = 'recruitment.centre') %>%
  mutate(Subject_ID = tolower(str_trim(as.character(Subject_ID))))

# --- Merge: add Age_FU2 to existing data
updated_df <- demographics_df %>%
  left_join(sex_rec_df, by = "Subject_ID")

# --- Overwrite the original file with the updated data
write.xlsx(updated_df, demographics_path, rowNames = FALSE)

cat("âœ… 'imagen_demographics.xlsx' updated with Age_FU2column.\n")
