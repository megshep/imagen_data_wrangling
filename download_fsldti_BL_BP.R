# FTP login information
ftp_user <- "msheppard"
ftp_password <- "[password]"
ftp_url <- "sftp://imagen2.cea.fr"

# Read user codes from CSV (User codes are Participant IDs)
csv_file_path <- "S:/niamh_project/CTQ/final_data.csv"
data <- read.csv(csv_file_path)
user_codes <- data$`User.code`

# Local output path
local_directory <- "S:/niamh_project/fu3_scans"

# Define the function to download files for one user
download_user_files <- function(user_code) {
  clean_user_code <- gsub("[^0-9]", "", user_code)  # Remove non-numeric characters (-I)
  
  # Correct FTP listing command - this is where the path is to change if you want a different timepoint
  getListOfFilesCommand <- paste(
    "c:/curl/bin/curl.exe --insecure -k --user", 
    paste0(ftp_user, ":", ftp_password), 
    paste0("sftp://imagen2.cea.fr/data/imagen/2.7/FU3/imaging/fsl_dti/", clean_user_code, "/")
  )
  
  # Get a list of files in the directory
  directory_listing <- tryCatch(
    system(getListOfFilesCommand, intern = TRUE),
    error = function(e) return(NULL)
  )
  
  if (is.null(directory_listing)) {
    cat("Error retrieving files for user:", clean_user_code, "\n")
    return(NULL)
  }
  
  filenames <- sapply(directory_listing, function(line) {
    fields <- strsplit(line, "\\s+")[[1]]
    fields[length(fields)]
  })
  
  # --- Updated regex to grab all 4 types: bvec, bval, dti.nii.gz, dti_ecc.nii.gz ---
  valid_patterns <- paste0(
    "^", clean_user_code, "_dti(_ecc)?\\.nii\\.gz$",   # _dti.nii.gz and _dti_ecc.nii.gz
    "|^", clean_user_code, "_dti\\.(bvec|bval)$"       # .bvec and .bval
  )

  
  # Loop through filenames and download matching ones
  for (f in filenames) {
    if (grepl(valid_patterns, f)) {
      
      # Construct the remote file path
      remote_file <- paste0("/data/imagen/2.7/FU3/imaging/fsl_dti/", clean_user_code, "/", f)
      ftp_full_url <- paste0(ftp_url, remote_file)
      
      # Define the local path where the file will be saved
      local_file <- file.path(local_directory, paste0(clean_user_code, "_", f))
      
      # Build the curl command
      curl_command <- paste(
        "c:/curl/bin/curl.exe --insecure --verbose --user", 
        paste0(ftp_user, ":", ftp_password), 
        "--retry 3",
        "--retry-delay 60",
        "--max-time 3600",
        "--output", shQuote(local_file),
        ftp_full_url
      )
      
      # Run the system curl command and check success
      result <- system(curl_command)
      if (result == 0) {
        print(paste("Downloaded:", f, "to", local_file))
      } else {
        print(paste("FAILED:", f))
      }
      
      # 60-second delay between downloads
      for (i in 60:1) {
        cat("Waiting", i, "seconds...\r")
        flush.console()
        Sys.sleep(1)
      }
      cat("\n")
    }
  }
  
  return(paste("Done with user:", clean_user_code))
}

# Process each user code sequentially
for (user_code in user_codes) {
  download_user_files(user_code)
}

print("Downloads Complete")
