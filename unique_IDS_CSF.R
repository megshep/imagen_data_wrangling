paths <- readLines("all_files.txt")

# Extract only the filename (remove path)
filenames <- basename(paths)  # removes everything before last /

# Remove suffixes _BL, _FU2, _FU3 and .nii
ids_clean <- gsub("(_BL|_FU2|_FU3)?\\.nii$", "", filenames)

# Remove duplicates
ids_unique <- unique(ids_clean)

# Optional: sort the IDs
ids_unique <- sort(ids_unique)

# Save to new file
writeLines(ids_unique, "unique_ids.txt")

# Print result
print(ids_unique)
