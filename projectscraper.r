
# Install and load necessary packages
install.packages("rvest")
install.packages("dplyr")
library(rvest)
library(dplyr)

# URL of the webpage to scrape
url <- "https://www.santafe.edu/engage/learn/projects/2022-csss"

# Read HTML content from the URL
html_content <- read_html(url)

# Extract all the tables
tables <- html_content %>% html_nodes("table")

# Initialize an empty data frame to store results
projects_data <- data.frame(Name = character(), Institution = character(), ProjectTitle = character())

# Extract project titles
project_titles <- html_content %>% 
  html_nodes("div.collapsible-item-heading") %>% 
  html_text(trim = TRUE)

# Loop through each table and extract names and institutions
for (i in seq_along(tables)) {
  rows <- tables[[i]] %>% html_nodes("tr")
  
  for (row in rows) {
    name <- row %>% html_nodes("strong") %>% html_text(trim = TRUE)
    institution <- row %>% html_nodes("p") %>% html_text(trim = TRUE)
    
    # Store in data frame
    projects_data <- rbind(projects_data, data.frame(Name = name, Institution = institution, ProjectTitle = project_titles[i]))
  }
}

# Print the combined data
print(projects_data)

#---------------------------------------------------------------------

install.packages("rvest")
install.packages("dplyr")
install.packages("purrr")
library(rvest)
library(dplyr)
library(purrr)

project_scraper <- function(url){
  
  # Read HTML content from the URL
  html_content <- read_html(url)
  
  # Extract all the tables
  tables <- html_content %>% html_nodes("table")
  
  # Extract project titles
  project_titles <- html_content %>% 
    html_nodes("div.collapsible-item-heading") %>% 
    html_text(trim = TRUE)
  
  # Create a list to store project data frames
  projects_list <- list()
  
  # Loop through each table and extract names and institutions
  for (i in seq_along(tables)) {
    rows <- tables[[i]] %>% html_nodes("tr")
    project_info <- map(rows, ~{
      name <- .x %>% html_nodes("strong") %>% html_text(trim = TRUE)
      institution <- .x %>% html_nodes("p") %>% html_text(trim = TRUE)
      return(data.frame(Name = name, Institution = institution))
    })
    
    # Combine data for each project into one data frame
    project_data <- bind_rows(project_info)
    
    # Add a "ProjectName" column to the data frame
    project_data$ProjectName <- project_titles[i]
    
    # Append the data frame to the list
    projects_list[[i]] <- project_data
  }
  
  # Concatenate all project data frames into one
  final_dataframe <- do.call(rbind, projects_list)
  )
  write.csv(final_dataframe, "output.csv", row.names = FALSE)
  
  return(final_dataframe)
}


