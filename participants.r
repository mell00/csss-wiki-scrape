library(rvest)

scrape_participants <- function(page_url){
  
  tryCatch({
  # Read the HTML content of the page
  page <- read_html(page_url)
  
  # CSS selector to find the hyperlink by its label
  xpath_selector <- '//a[text()="Participants"]'
  
  # Extract the link
  participant_link <- page %>%
    html_node(xpath = xpath_selector) %>%
    html_attr('href')
  
  print(participant_link)}, 
  
  error = function(e) {
    return(NA)  # Return NA in case of an error
  })}

scrape_participants(page_url)
