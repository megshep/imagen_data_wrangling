#This is the login information for the IMAGEN database including the SFTP URL. 
ftp_user <- "msheppard"
ftp_password <- "[password]"
ftp_url <- "sftp://imagen2.cea.fr"

# Read user codes from CSV (User codes are Participant IDs)
csv_file_path <- "S:/Meg_Stuff/brenda_project/CTQ_FU2.csv"
data <- read.csv(csv_file_path)
user_codes <- data$`User.code`

# Local output path
local_directory <- "S:/Meg_Stuff/brenda_project"

# Define the function to download files for one user
download_user_files <- function(user_code) {
  clean_user_code <- gsub("[^0-9]", "", user_code)  # Remove any non-numeric characters, this is important as all IDs have -I on them which needs to be removed
  
  # Correct FTP listing command
  getListOfFilesCommand <- paste(
    "c:/curl/bin/curl.exe --insecure -k --user", 
    paste0(ftp_user, ":", ftp_password), 
    paste0("sftp://imagen2.cea.fr/data/imagen/2.7/BL/imaging/fsl_dti/", clean_user_code, "/")
  )
  
  # Get a list of files in the directory
  directory_listing <- tryCatch(system(getListOfFilesCommand, intern = TRUE), error = function(e) return(NULL))
  
  if (is.null(directory_listing)) {
    cat("Error retrieving files for user:", clean_user_code, "\n")
    return(NULL)
  }
  
  filenames <- sapply(directory_listing, function(line) {
    fields <- strsplit(line, "\\s+")[[1]]
    fields[length(fields)]
  })
  
  # Define the correct file pattern: user_code followed by "_dti" and either .nii, .bvec, or .bval (as these are the files we're interestedi in downloading)
  valid_patterns <- paste0("^", clean_user_code, "_dti\\.(nii|bvec|bval)$")
  
  # Loop through filenames and download matching ones
  for (f in filenames) {
    if (grepl(valid_patterns, f)) {
      
      # Correctly construct the remote file path: /data/imagen/2.7/BL/imaging/fsl_dti/{usercode}/{usercode}_dti.{nii.gz|bvec|bval}
      remote_file <- paste0("/data/imagen/2.7/BL/imaging/fsl_dti/", clean_user_code, "/", clean_user_code, "_dti", sub(".*(_dti.*)", "\\1", f))
      ftp_full_url <- paste0(ftp_url, remote_file)
      
      # Define the local path where the file will be saved
      local_file <- file.path(local_directory, paste0(clean_user_code, "_", f))  # Save as usercode_filename.ext
      
      # Build the curl command for the system call to download the file
      curl_command <- paste(
        "c:/curl/bin/curl.exe --insecure --verbose --user", 
        paste0(ftp_user, ":", ftp_password), 
        "--retry 3",  # Retry 3 times
        "--retry-delay 60",  # Wait 60 seconds between retries
        "--max-time 3600",  # Set max time (1 hour) per download attempt
        "--output", shQuote(local_file),  # Output file path
        ftp_full_url  # Remote URL to download from
      )
      
      # Run the system curl command to download the file
      system(curl_command)
      print(paste("Downloaded:", f, "to", local_file))
      
      # Add a 60 second delay between downloads to prevent server throttling
      for (i in 60:1) {
        cat("Waiting", i, "seconds...\r")  # \r returns cursor to start of line
        flush.console()                    # Ensures immediate output
        Sys.sleep(1)
      }
      cat("\n")  # New line after countdown
    }
  }
  
  return(paste("Done with user:", clean_user_code))
}

# Process each user code sequentially
for (user_code in user_codes) {
  download_user_files(user_code)
}

print("Downloads Complete")
