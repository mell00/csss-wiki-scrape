# Variation of "scrape_names_1" function that also gathers the subject(s)
# of study

scrape_names_1 <- function(html_content) {
  # Convert the HTML string to an HTML document
  page <- read_html(html_content)
  
  # Extract the participant information contained within <p> tags
  participant_nodes <- page %>% html_nodes("p") %>% html_text()
  
  # Initialize vectors for names, institutions, and subjects
  names <- vector("character", length(participant_nodes))
  institutions <- vector("character", length(participant_nodes))
  subjects <- vector("character", length(participant_nodes))
  
  # Iterate over each node to extract the name, institution, and subject
  for (i in seq_along(participant_nodes)) {
    # Split the text at the line break to separate name, institution, and subject
    split_text <- strsplit(participant_nodes[i], "\n")[[1]]
    
    # Extract the name (first part of the split text)
    names[i] <- trimws(split_text[1])
    
    # Extract the subject (second part of the split text)
    subjects[i] <- ifelse(length(split_text) > 1, trimws(split_text[2]), NA)
    
    # Extract the institution (third part of the split text)
    institutions[i] <- ifelse(length(split_text) > 2, trimws(split_text[3]), NA)
  }
  
  # Extract year
  years <- extract_year_from_url(html_content)
  
  # Create empty link column
  links <- rep(NA, length(names))
  
  # Create a dataframe with the names, institutions, subjects, and links
  data <- data.frame(Year = years, Name = names, Link = links, Institution = institutions, Subject = subjects, stringsAsFactors = FALSE)
  
  return(data)
}

