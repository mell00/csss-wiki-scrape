library(readxl)
library(dplyr)
library(openxlsx)

# Load the data from the Excel sheets
excel_file_path <- "CSSS Data.xlsx"
id_name_data <- read_excel(excel_file_path, sheet = "Participant Data")
replace_data <- read_excel(excel_file_path, sheet = "Project Data")

# Ensure 'Name' and 'ID' in id_name_data are character type
id_name_data <- mutate(id_name_data, Name = as.character(Name), ID = as.character(ID))

# Function to find ID by name
find_id_by_name <- function(name) {
  # Convert name to lowercase for case-insensitive matching
  name_lower <- tolower(name)
  
  # Attempt to find a matching ID
  matched_id <- id_name_data %>%
    filter(tolower(Name) == name_lower) %>%
    pull(ID)
  
  # Return the ID if found; otherwise, return the original name
  if (length(matched_id) > 0) return(matched_id)
  else return(name)
}

# Apply the find_id_by_name function to each "Team Member" column
for (i in 1:11) {
  column_name <- paste0("Team Member ", i)
  
  # Check if the column exists in replace_data
  if (column_name %in% colnames(replace_data)) {
    # Replace each name with its corresponding ID (if found)
    replace_data[[column_name]] <- sapply(replace_data[[column_name]], find_id_by_name)
  }
}

# Replace NA values with an empty string in replace_data before writing
replace_data <- replace_data %>%
  mutate(across(everything(), ~ifelse(is.na(.), "", .)))

output_file_path <- "Updated_CSSS Data.xlsx"

# Attempt to write the updated data back to an Excel file again
write.xlsx(replace_data, output_file_path, sheetName = "Updated Project Data", overwrite = TRUE)

