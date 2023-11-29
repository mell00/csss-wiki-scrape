library(httr)
library(jsonlite)
library(rvest)
library(dplyr)
source("participants.r")
source("baselink_filter.r")
source("abs_url.r")

# Assuming you have a DataFrame named 'links_df' with a column 'links_urls' containing URLs
# links_df <- data.frame(links_urls = c("url1", "url2", ...))

# Use sapply or lapply to apply the function to each URL and compile the results
participants_links <- sapply(links_df$URLs, scrape_participants, USE.NAMES = FALSE)
participants_links <- sapply(participants_links, make_absolute_url)

# The result is a vector of "Participants" links
names(participants_links) = NULL
print(participants_links)



#-------------------------------------------------------------------------------------------

#Works for 1 - 10, 13, 14

scrape_names_1 <- function(html_content) {
  # Convert the HTML string to an HTML document
  page <- read_html(html_content)
  
  # Extract the names (enclosed in <b> tags within <p> tags)
  names <- page %>% html_nodes("p > b") %>% html_text(trim = TRUE)
  
  # Create a dataframe with the names
  data <- data.frame(Name = names, stringsAsFactors = FALSE)
  
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
  
  # Create a dataframe with the names and links
  data <- data.frame(Name = names, Link = abs_links, stringsAsFactors = FALSE)
  
  
  # Exclude entries where Name is actually a link or Link does not contain 'santafe.edu'
  valid_entries <- !grepl("http", data$Name, ignore.case = TRUE) & grepl("santafe.edu", data$Link, ignore.case = TRUE)
  data <- data[valid_entries, ]
  
  # Remove non-alphanumeric characters from all names
  data$Name <- gsub("[^[:alnum:] ]", "", data$Name)
  
  # Reset row indices
  row.names(data) <- NULL
  
  return(data)
}

#scrape_names_1(participants_links[10])

#scrape_participants_info_2(participants_links[15])

#participants_links[11]


