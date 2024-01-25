# Load required libraries
library(dplyr)

# Read the CSV file containing names (replace 'file.csv' with your file path)
data <- read.csv("CSSS Data - Participant Data.csv")

# Create a function to generate random ID numbers
generate_random_ids <- function(num_names) {
  set.seed(123)  # Set a seed for reproducibility
  sample(10000:99999, num_names, replace = FALSE)
}

# Generate random IDs for each unique name
unique_names <- unique(data$Name)  # Assuming 'Name' is the column with names
num_names <- length(unique_names)

# Generate unique IDs for each unique name
unique_ids <- generate_random_ids(num_names)

# Create a mapping between names and IDs
name_id_mapping <- data.frame(Name = unique_names, ID = unique_ids)

# Merge the mapping with the original data
data <- merge(data, name_id_mapping, by = "Name", all.x = TRUE)

# Write the data with IDs to a new CSV file (replace 'output_file.csv' with desired output file path)
write.csv(data, "output_file.csv", row.names = FALSE)

# View the data with IDs
data

