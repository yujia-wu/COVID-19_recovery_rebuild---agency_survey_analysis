#### Preamble ####
# Purpose: Use the opendatatoronto package to get data on the COIVD-19 survey results of community agencies
# Author: Yujia Wu
# Date: 29 January 2021
# Contact: yujia.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites: None



#### Workspace set-up ####
#install.packages("utf8")
library(opendatatoronto)
library(tidyverse)


#### Get data ####
# get the accompanying "readme" file
agency_readme <-
   opendatatoronto::search_packages('COVID-19 Recovery and Rebuild') %>%
   opendatatoronto::list_package_resources() %>% 
   filter(name == 'Agency Survey Results readme') %>% 
   select(id) %>% 
   get_resource()


# In order to get the dataset, I tried using the opentorontodata package to get the data but it did not work
# the downloaded dataset is empty for some reason
#raw_data <-
#   opendatatoronto::search_packages('COVID-19 Recovery and Rebuild') %>%
#   opendatatoronto::list_package_resources() %>% 
#   filter(name == 'Agency Survey Results') %>% 
#   select(id) %>% 
#   get_resource()

# Instead, use read_csv function to read in the dataset from the link below
# link to the dataset provided by Rohan Alexander at https://inf2178workspace.slack.com/archives/C01HX5T55QB/p1612036721094200?thread_ts=1611965707.088400&cid=C01HX5T55QB
raw_data <- read_csv('https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/9d6c5c52-e359-47dc-99e7-870261ca03d9/resource/c48a4f81-b646-4fd6-b9a4-0f652feb9e94/download/agency-survey-results.csv')


#### Save data ####
# save the "readme" file to inputs/data
write_csv(agency_readme, 'inputs/data/readme.csv')

# save the dataset to inputs/data
write_csv(raw_data, 'inputs/data/agency_survey_rawdata.csv')
# save the dataset to outputs/paper (where the R markdown file is) because the R markdown will not knit if the data is not in its directory
write_csv(raw_data, 'outputs/paper/agency_survey_rawdata.csv')
