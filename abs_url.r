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