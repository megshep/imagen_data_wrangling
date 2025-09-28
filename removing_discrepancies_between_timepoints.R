library(openxlsx)
library(fs)
library(stringr)

# Read valid subject IDs from Excel, assuming that there is a column titled 'Common_Subject_IDs'
subject_ids_path <- "S:/Meg_Stuff/subject_ids_common_p2.xlsx"
subject_ids_df <- read.xlsx(subject_ids_path)
valid_ids <- tolower(str_trim(subject_ids_df$Common_Subject_IDs))

# Define source folders and corresponding extras subfolders - this is so that there is a clear folder to move any spare files to
folder_info <- list(
  FU1_nifti = list(path = "S:/Meg_Stuff/FU2_nifti", extras_sub = "FU2_Extras"),
  FU2_nifti = list(path = "S:/Meg_Stuff/FU3_nifti", extras_sub = "FU3_Extras"),
  BL_nifti  = list(path = "S:/Meg_Stuff/BL_nifti",  extras_sub = "BL_Extras")
)

# Base extras folder
base_extras <- "S:/Meg_Stuff/extras"
dir_create(base_extras)

# Function to move unmatched files to the appropriate subfolder
move_extras <- function(folder_path, extras_subfolder, valid_ids, base_extras) {
  files <- list.files(folder_path, full.names = TRUE)
  subfolder_path <- file.path(base_extras, extras_subfolder)
  dir_create(subfolder_path)
  
  for (file in files) {
    file_name <- basename(file)
    
    # Extract subject ID by removing .nii or .nii.gz
    base_id <- str_remove(file_name, "\\.nii\\.gz$|\\.nii$")
    base_id <- tolower(str_trim(base_id))
    
    if (!(base_id %in% valid_ids)) {
      dest_file <- file.path(subfolder_path, file_name)
      file_move(file, dest_file)
      cat("Moved:", file_name, "to", dest_file, "\n")
    }
  }
}

# Loop over each folder
for (folder_name in names(folder_info)) {
  path <- folder_info[[folder_name]]$path
  extras_sub <- folder_info[[folder_name]]$extras_sub
  move_extras(path, extras_sub, valid_ids, base_extras)
}

cat("Done. Unmatched files sorted into extras subfolders.\n")
