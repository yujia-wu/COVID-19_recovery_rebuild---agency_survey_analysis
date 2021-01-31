#### Preamble ####
# Purpose: use the processed data to make plots
# Author: Yujia Wu
# Date: 30 January 2021
# Contact: yujia.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites:
#  - need to go through the steps in the "01_data_cleaning" R script to prepare the data for visualization


#### Workspace setup ####
library(ggplot2)
library(scales)
library(kableExtra)


#### Create a table for COVID-19 impact ####
# create a new column to the impact_table dataframe showing the percentage of impacts voted by respondents
impact_table$percentage <- with(impact_table, frequency/nrow(impact)) %>% scales::percent()

# sort the dataframe by percentage
impact_table <- impact_table[order(impact_table$frequency, decreasing = TRUE), ]

# create a table (will show up in the pdf file)
knitr::kable(impact_table, caption = 'How community agencies have been affected by COVID-19', row.names = FALSE)



#### Create a bar chart for impact of COVID-19 on community agencies ####
impact_bar <-
   ggplot(impact_table, aes(x = impact_types, y = frequency)) +
   geom_bar(stat = 'identity', fill = '#85A9D2') +
   # label the bars. Code got from http://www.sthda.com/english/wiki/ggplot2-barplots-quick-start-guide-r-software-and-data-visualization
   geom_text(aes(label=frequency), vjust=-0.3, size=3.5) + 
   labs (x = "Types of impact",
         y = "Number of agencies",
         title = "How community agencies have been affected by COVID-19",
         caption = "Source: 'Agency Survey Results on COVID-19 Recovery And Rebuild' from the City of Toronto's Open Data Portal.")

# rotate the x-axis labels. Code got from https://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2
# change the text size of x and y axis and the title
impact_bar + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
   theme(axis.text=element_text(size=10), axis.title=element_text(size=14,face="bold"), plot.title = element_text(size=18))



#### Create a table for support types ####
# create a new column to the support_table dataframe showing the percentage of support voted by respondents
support_table$percentage <- with(support_table, frequency/nrow(sec_support)) %>% scales::percent()

# sort the dataframe by percentage
support_table <- support_table[order(support_table$frequency, decreasing = TRUE), ]

# create a table (will show up in the pdf file)
knitr::kable(support_table, caption = 'Support that agencies need to survive the second wave', row.names = FALSE)

#### Create a bar chart for types of support needed for the second wave ####
support_bar <-
   ggplot(support_table, aes(x = support_types, y = frequency)) +
   geom_bar(stat = 'identity', fill = '#AAD1B3') +
   geom_text(aes(label=frequency), vjust=-0.3, size=3.5) + 
   labs (x = "Types of support",
         y = "Number of agencies",
         title = "Support that community agencies need for the second wave",
         caption = "Source: 'Agency Survey Results on COVID-19 Recovery And Rebuild' from the City of Toronto's Open Data Portal.")

support_bar + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
   theme(axis.text=element_text(size=10), axis.title=element_text(size=14,face="bold"), plot.title = element_text(size=18))





