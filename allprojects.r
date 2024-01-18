source("projectscraper.r")
source("cssweblinks.r")

participants_links <- sapply(csss_web_links, project_scraper, USE.NAMES = FALSE)
