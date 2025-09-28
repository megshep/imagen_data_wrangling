library(openxlsx)

# Define the path to your folder with the files
folder_path <- "S:/Meg_Stuff/FU3_nifti"  

# List all files in the folder (no need for full names)
files <- list.files(folder_path, full.names = FALSE)

# Remove extensions (.nii.gz, .nii) for all files as I just want a list of the IDs themselves and not the file names, skip this step if you want file names
ids <- sub("\\.nii\\.gz$|\\.nii$", "", files)

# Remove any duplicates (to ensure each ID is listed only once, as .nii.gz and .nii are both present)
unique_ids <- unique(ids)
# Create a data frame with the unique IDs (without file extensions) - this is important as I have each files zipped and unzipped in the folder, so don't want repeats and don't want extensions
id_df <- data.frame(Subject_ID = unique_ids, stringsAsFactors = FALSE)

# Define the output file name
file_name <- paste0("subject_ids_FU3_unique_p2", ".xlsx")

# Set the output Excel file path
output_excel <- file.path("S:/Meg_Stuff/FU3_nifti", file_name)

# Write the data frame to Excel
write.xlsx(id_df, output_excel, rowNames = FALSE)

# Done
cat("Excel file created at:", output_excel, "\n")
