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
print(participants_links)


