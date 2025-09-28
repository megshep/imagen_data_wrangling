#Server information - this is the log in information and the server url itself
ftp_user <- "msheppard"
ftp_password <- "[password]"
ftp_url <- "sftp://imagen2.cea.fr"  # FTP URL (this is the specific one for IMAGEN]

# Specify the local path to the CSV file 
csv_file_path <- "S:/Meg_Stuff/BL_nifti/CTQ_FU2.csv"  # Path to the CSV file with the participant IDs

# Read the CSV file 
data <- read.csv(csv_file_path)

# This is the Participant IDs column - in the imagen database it's in a column titled 'User.code' 
user_codes <- data$`User.code` 

# Local directory where you want to save the files (output directory)
local_directory <- "S:/Meg_Stuff/BL_nifti"      

# Loop through each user code and download the matching file
for (user_code in user_codes) {
  
  #remove alphabetic letter and hyphen from the user code (all of them had -I in them for some reason, so this needed to be removed first)
  user_code <- gsub("[^0-9]", "", user_code)
  
  # This says look in this path - this is important because in the IMAGEN database, the scans are saved in folders named under their Participant ID so this needs to be built into the pathway
  remote_file <- paste0("/data/imagen/2.7/BL/imaging/nifti/",user_code, "/SessionA/ADNI_MPRAGE/")
  
  # Creates a local file path to save the files in the directory specified above as their participant ID.nii.gz e.g., 000000126629162.nii.gz
  local_file <- file.path(local_directory, paste0(user_code, ".nii.gz"))
  
  # This logs into the FTP URL with the authentication information (username, password above)
  ftp_full_url <- paste0(ftp_url, remote_file)

  # Get a list of files in the directory of the user code using system call to curl with -k parameter  (make sure path to curl is correct! this has to be saved somewhere on the local computer!)
  getListOfFilesCommand <- paste("c:/curl/bin/curl.exe --insecure -k --user", paste0(ftp_user, ":", ftp_password), paste0("sftp://imagen2.cea.fr/data/imagen/2.7/BL/imaging/nifti/",user_code,"/SessionA/ADNI_MPRAGE/"))
  
  directory_listing <- system(getListOfFilesCommand, intern = TRUE)
  
  filenames <- sapply(directory_listing, function(line) {
    # Split the line by whitespace and take the last element
    fields <- strsplit(line, "\\s+")[[1]]
    fields[length(fields)]
  })
  
  #Go through each of the filenames in the directory and get the filename that ends in gz.
  for (f in filenames) {
    
    if (grepl("\\.gz$", f)) {
      
      remote_file <- paste0("/data/imagen/2.7/BL/imaging/nifti/",user_code,"/SessionA/ADNI_MPRAGE/", f)
      ftp_full_url <- paste0(ftp_url, remote_file)
      
      # Build the curl command for the system call to download the file (make sure the path to curl is correct!)
      #curl_command <- paste("c:/curl/bin/curl.exe --insecure --verbose --user", paste0(ftp_user, ":", ftp_password), ftp_full_url)  # Remote URL to download from
      
      # Build the curl command for the system call to download the file (make sure the path to curl is correct!). This includes a 60-second blocker to prevent server throttling
      # Do not remove this or the files won't download and there will be server throttling
      curl_command <- paste(
        "c:/curl/bin/curl.exe --insecure --verbose --user", 
        paste0(ftp_user, ":", ftp_password), 
        "--retry 3",  # Retry 3 times
        "--retry-delay 60",  # Wait 60 seconds between retries
        "--max-time 3600",  # Set max time (1 hour) per download attempt
        #"--ftp-create-dirs",  # Create any necessary directories
        "--output", local_file,  # Output file path
        ftp_full_url  # Remote URL to download from
      )
      
      # Run the system curl command to download the file
      system(curl_command)
      print(paste("Downloaded:", f, "to", local_file))
    }
  }
  
  #This produces the 60 second delay and also provides a comment to tell you it's waiting for x amount of seconds
  for (i in 60:1) {
    cat("Waiting", i, "seconds...\r")  # \r returns cursor to start of line
    flush.console()                    # Ensures immediate output
    Sys.sleep(1)
  }
  cat("\n")  # New line after countdown
}

print("Downloads Complete")
