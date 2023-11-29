library(httr)
library(jsonlite)
library(rvest)
library(dplyr)

main_df <- data.frame(Year = c(1), Name = character(1), 
                      Affiliation = character(1), Country = character(1),
                      )