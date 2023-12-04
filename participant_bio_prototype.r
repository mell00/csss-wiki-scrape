source("participant_loop.r")
library(rvest)

# URL of the page
url <- "https://wiki.santafe.edu/index.php/Christopher_Fussner"

# Read the HTML content from the URL
page <- read_html(url)

# Extract the text within <p>s
paragraphs <- page %>% html_nodes("p") %>% html_text(trim = TRUE)

# Split the text by newline characters
info <- unlist(strsplit(paragraphs, "\n"))

# Create a data frame with a single column
data <- data.frame(Info = info, stringsAsFactors = FALSE)

# Print the result
print(data)
