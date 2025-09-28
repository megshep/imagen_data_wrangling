# FTP server details - this is specific to the imagen database
ftp_user <- "msheppard"
ftp_password <- "[password]"
ftp_url <- "sftp://imagen2.cea.fr"  # FTP URL - specific for imagen

# Specify the local path to the CSV file
csv_file_path <- "S:/Meg_Stuff/BL_nifti/CTQ_FU2.csv"  

# Read the CSV file
data <- read.csv(csv_file_path)

# Extract the 'User code' column  - this is what the participant IDs are saved as
user_codes <- data$`User.code` 

# Local directory where you want to save the files
local_directory <- "S:/Meg_Stuff/FU3_nifti"      

# Loop through each user code and download the matching file
for (user_code in user_codes) {
  
  # Remove alphabetic letters and hyphens from the user code because each code has -I in it that needs to be removed
  user_code <- gsub("[^0-9]", "", user_code)
  
  # Construct the remote file path - this is needed because the MRI scans are saved in files titled by their own Participant ID, so this needs to be built into the remote file path
  remote_file <- paste0("/data/imagen/2.7/BL/imaging/nifti/", user_code, "/SessionA/ADNI_MPRAGE/")
  
  # Local file path
  local_file <- file.path(local_directory, paste0(user_code, ".nii.gz"))
  
  # Check if the file already exists locally
  if (file.exists(local_file)) {
    print(paste("File for user code", user_code, "already exists. Skipping download."))
    next  # Skip to the next user code
  }
  
  # Construct FTP URL with authentication, using the URL-encoded password
  ftp_full_url <- paste0(ftp_url, remote_file)
  
  getListOfFilesCommand <- paste("c:/curl/bin/curl.exe --insecure -k --user", paste0(ftp_user, ":", ftp_password), paste0("sftp://imagen2.cea.fr/data/imagen/2.7/BL/imaging/nifti/", user_code, "/SessionA/ADNI_MPRAGE/"))
  
  # Get a list of files in the directory of the user code using the system call to curl with -k parameter (make sure path to curl is correct!)
  directory_listing <- system(getListOfFilesCommand, intern = TRUE)
  
  filenames <- sapply(directory_listing, function(line) {
    # Split the line by whitespace and take the last element
    fields <- strsplit(line, "\\s+")[[1]]
    fields[length(fields)]
  })
  
  # Go through each of the filenames in the directory and get the filename that ends in gz
  for (f in filenames) {
    
    if (grepl("\\.gz$", f)) {
      
      remote_file <- paste0("/data/imagen/2.7/BL/imaging/nifti/", user_code, "/SessionA/ADNI_MPRAGE/", f)
      ftp_full_url <- paste0(ftp_url, remote_file)
      
      # Build the curl command for the system call to download the file (make sure path to curl is correct!)
      curl_command <- paste(
        "c:/curl/bin/curl.exe --insecure --verbose --user", 
        paste0(ftp_user, ":", ftp_password), 
        "--retry 3",  # Retry 3 times
        "--retry-delay 60",  # Wait 60 seconds between retries
        "--max-time 3600",  # Set max time (1 hour) per download attempt
        "--output", local_file,  # Output file path
        ftp_full_url  # Remote URL to download from
      )
      
      # Run the system curl command to download the file
      system(curl_command)
      print(paste("Downloaded:", f, "to", local_file))
    }
  }
  
  # Add a 60-second delay between downloads to prevent server throttling
  for (i in 60:1) {
    cat("Waiting", i, "seconds...\r")  # \r returns cursor to start of line
    flush.console()                    # Ensures immediate output
    Sys.sleep(1)
  }
  cat("\n")  # New line after countdown
}

print("Downloads Complete")
