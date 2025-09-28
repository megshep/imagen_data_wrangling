library(openxlsx)
library(dplyr)
library(stringr)

#specify the paths to the two Excel sheets (this isn't always needed but good practice for if they're saved in separate places from the working directory)
demographics_path <- "S:/Meg_Stuff/imagen_demographics/imagen_demographics.xlsx"
sex_rec_path <- "S:/Meg_Stuff/imagen_demographics/IMAGEN_sex_recruitment_centre.xlsx"

# Load the existing demographics sheet that you want to add the columns to
demographics_df <- read.xlsx(demographics_path)
colnames(demographics_df)[1] <- "Subject_ID"  # Standardising the column names
demographics_df$Subject_ID <- tolower(str_trim(as.character(demographics_df$Subject_ID)))

#Load in the additional data from the pathways specified above (here we're loading in sex and recruitment centre information to add this to the overall demographics)
#we're then selecting the relevant column names and adding them as an additional column
sex_rec_df <- read.xlsx(sex_rec_path)
colnames(sex_rec_df)[1] <- "Subject_ID"
sex_rec_df <- sex_rec_df %>%
  select(Subject_ID, Recruitment_Centre = 'recruitment.centre') %>%
  mutate(Subject_ID = tolower(str_trim(as.character(Subject_ID))))

#Merge this information to the existing data in the original datafra,e
updated_df <- demographics_df %>%
  left_join(sex_rec_df, by = "Subject_ID")

# save this as a .xlsx file 
write.xlsx(updated_df, demographics_path, rowNames = FALSE)

cat('imagen_demographics.xlsx' updated with Age_FU2column.\n")
