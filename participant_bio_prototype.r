library(readxl)
library(rvest)
library(purrr)
library(dplyr)
library(openxlsx)

# Function to read Excel, extract biographies based on links, and write to a new Excel file
process_participant_links <- function(input_file_path, output_file_path, sheet_name = "Participant Data", url_column_name = "Link") {
  # Read the Excel file into a dataframe
  df <- read_excel(input_file_path, sheet = sheet_name)
  
  # Check if the URL column exists in the dataframe
  if (!url_column_name %in% names(df)) {
    stop("The specified URL column does not exist in the dataframe.")
  }
  
  # Extract biography text function
  extract_bio <- function(url) {
    if(is.na(url)) return(NA)  # Handle NA URLs
    # Attempt to read HTML content from the URL
    page <- tryCatch({
      read_html(url)
    }, error = function(e) NA)
    
    if (!is.na(page)) {
      paragraphs <- page %>% html_nodes("p") %>% html_text(trim = TRUE)
      info <- unlist(strsplit(paragraphs, "\n"))
      bio_text <- paste(info, collapse = " ")
      return(bio_text)
    } else {
      return(NA)  # Return NA for errors or nonexistent links
    }
  }
  
  # Apply extract_bio to each link in the URL column
  biographies <- map_chr(df[[url_column_name]], possibly(extract_bio, otherwise = NA))
  
  # Add the biographies as a new column to the dataframe
  df$Biography <- biographies
  
  # Write the updated dataframe to a new Excel file
  write.xlsx(df, file = output_file_path, overwrite = TRUE)
  
  cat("Process completed. Output written to:", output_file_path, "\n")
}

# Example usage
input_file_path <- "CSSS Data.xlsx"  # Update this path
output_file_path <- "path_to_your_output_excel_file.xlsx"  # Update this path

process_participant_links(input_file_path, output_file_path, sheet_name = "Participant Data", url_column_name = "Link")
