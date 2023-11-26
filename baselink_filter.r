library(httr)
library(jsonlite)
library(rvest)
library(dplyr)

retrieve_filtered_links <- function(page_title, filter_text) {
  # Base URL for the Santa Fe Institute's MediaWiki API
  base_url <- "https://wiki.santafe.edu/api.php"
  
  params <- list(
    action = "query",
    format = "json",
    titles = page_title,
    prop = "links",
    pllimit = "max"
  )
  
  response <- GET(url = base_url, query = params)
  data <- content(response, "text", encoding = "UTF-8")
  
  parsed_data <- fromJSON(data)
  
  links <- parsed_data$query$pages
  
  filtered_links <- lapply(links, function(page) {
    if (!is.null(page$links)) {
      links_data <- page$links
      return(links_data[grepl(filter_text, links_data$title), ])
    }
  })
  
  return(filtered_links)
}

page_title <- "Main Page"
filter_text <- "Complex Systems Summer School"
filtered_links <- unname(unlist(retrieve_filtered_links(page_title, filter_text)))
filtered_names <- filtered_links[filtered_links != "0"]

print(filtered_names)



#-------------------------------------------------------------------

page_url <- "https://wiki.santafe.edu/index.php/Main_Page#Past_Events"

# Fetch and parse the HTML content of the page
page_content <- read_html(page_url)

# Extract links 
links <- page_content %>%
  html_nodes('.mw-parser-output a') %>%
  html_attr('href')

# Filter out links that do not contain the desired text
desired_text <- "Complex_Systems_Summer_School"
filtered_links <- links[grepl(desired_text, links)]

# Create a data frame
links_df <- data.frame(Names = filtered_names, URLs = rev(filtered_links))

# Print or process the data frame
print(links_df)


#---------------------------------------------------------------------


# Define the base URL for the wiki pages
base_url <- "https://wiki.santafe.edu"

# Function to convert relative URLs to absolute URLs
make_absolute_url <- function(relative_url) {
  if (startsWith(relative_url, "/")) {
    return(paste0(base_url, relative_url))
  } else {
    return(relative_url)
  }
}

# Assuming 'links_df' contains a column 'URLs' with relative URLs
links_df$URLs <- sapply(links_df$URLs, make_absolute_url)

# Print or process the updated data frame
print(links_df)
