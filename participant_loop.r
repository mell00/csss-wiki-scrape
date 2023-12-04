library(httr)
library(jsonlite)
library(rvest)
library(dplyr)
source("participants.r")
source("baselink_filter.r")
source("abs_url.r")

participants_links <- sapply(links_df$URLs, scrape_participants, USE.NAMES = FALSE)
participants_links <- sapply(participants_links, make_absolute_url)

# vector of "Participants" links
names(participants_links) = NULL
print(participants_links)


# Extract years from URLs
extract_year_from_url <- function(url) {
  # Pattern to match four consecutive digits
  pattern <- "\\d{4}"
  
  # Extracting the year
  year <- regmatches(url, regexpr(pattern, url))
  
  return(as.numeric(year))
}

#-------------------------------------------------------------------------------------------

#Works for 1 - 10, 13, 14

scrape_names_1 <- function(html_content) {
  # Convert the HTML string to an HTML document
  page <- read_html(html_content)
  
  # Extract the names (enclosed in <b> tags within <p> tags)
  names <- page %>% html_nodes("p > b") %>% html_text(trim = TRUE)
  
  # Extract year
  years <- extract_year_from_url(html_content)
  
  # Create empty link column
  links <- NA
  
  # Create a dataframe with the names
  data <- data.frame(Year = years, Name = names, Link = links, stringsAsFactors = FALSE)
  
  return(data)
}


# Works for all other years

scrape_participants_info_2 <- function(html_content) {
  # Convert the HTML string to an HTML document
  page <- read_html(html_content)
  
  # Extract the names and links (enclosed in <a> tags within <p> tags)
  participant_nodes <- page %>% html_nodes("p > a")
  names <- participant_nodes %>% html_text(trim = TRUE)
  links <- participant_nodes %>% html_attr("href")
  abs_links <- sapply(links, make_absolute_url)
  names(abs_links) <- NULL
  years <- extract_year_from_url(html_content)
  
  
  # Create a dataframe with the names and links
  data <- data.frame(Year = years, Name = names, Link = abs_links, stringsAsFactors = FALSE)
  
  
  # Exclude entries where Name is a url or Link does not contain 'santafe.edu'
  valid_entries <- !grepl("http", data$Name, ignore.case = TRUE) & grepl("santafe.edu", data$Link, ignore.case = TRUE)
  data <- data[valid_entries, ]
  
  # Remove non-alphanumeric characters from names
  data$Name <- gsub("[^[:alnum:] ]", "", data$Name)
  
  # Reset row indices
  row.names(data) <- NULL
  
  return(data)
}

scrape_names_1(participants_links[4])

scrape_participants_info_2(participants_links[22])

#-------------------------------------------------------------------------------------------

# Checking for links
run_pt_scrape <- function(url) {
  # Attempt to run the first scraping function
  result <- tryCatch({
    scrape_names_1(url)
  }, error = function(e) {
    # In case of an error, return NULL to signal a need for the second function
    NULL
  })
  
  # Check if result is NULL, when an error occurred in scrape_names_1
  if (is.null(result) || length(result[[1]]) < 6) {
    # Run the second scraping function if the first one failed
    result <- scrape_participants_info_2(url)
  }
  
  return(result)
}


result <- run_pt_scrape(participants_links[11])

length(result[[1]])

scrape_results <- lapply(participants_links, run_pt_scrape)

combined_results <- do.call(rbind, scrape_results)



#-------------------------------------------------------------------------------------------



