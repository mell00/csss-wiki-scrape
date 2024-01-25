source("projectscraper.r")
source("cssweblinks.r")

participants_links <- sapply(csss_web_links, project_scraper, USE.NAMES = FALSE)

install.packages("dplyr")
library(dplyr)

# Function to bind a list of data frames into one data frame
bind_dataframes <- function(dataframes_list) {
  if (length(dataframes_list) == 0) {
    stop("Input list is empty. Please provide a list of data frames.")
  }
  
  # Use bind_rows to combine all data frames in the list
  final_dataframe <- bind_rows(dataframes_list)
  
  return(final_dataframe)
}




data <- bind_dataframes(participants_links)



install.packages("tidyr")
library(tidyr)


# Number the team members within each project
data <- data %>%
  group_by(ProjectName) %>%
  mutate(TeamMember = paste("Team Member", row_number()))

# Use spread to create columns for each team member
wide_data <- data %>%
  select(ProjectName, TeamMember, Name) %>%
  mutate(TeamMember = factor(TeamMember, levels = unique(TeamMember))) %>% 
  spread(TeamMember, Name)

# Replace missing values with empty strings
wide_data[is.na(wide_data)] <- ""

# Print the restructured data frame
print(wide_data)

write.csv(wide_data, "output.csv", row.names = FALSE)

write.csv(wide_data, "output.csv", row.names = FALSE)
