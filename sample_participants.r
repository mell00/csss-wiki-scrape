library(rvest)

# sample URL of the webpage to scrape
page_url <- "https://wiki.santafe.edu/index.php/Complex_Systems_Summer_School_2018_(CSSS)"

scrape_participants <- function(page_url){
  # Read the HTML content of the page
  page <- read_html(page_url)
  
  # CSS selector to find the hyperlink by its label
  xpath_selector <- '//a[text()="Participants"]'
  
  # Extract the link
  participant_link <- page %>%
    html_node(xpath = xpath_selector) %>%
    html_attr('href')
  
  print(participant_link)
  
}

scrape_participants(page_url)
