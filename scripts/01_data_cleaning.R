#### Preamble ####
# Purpose: clean the survey data downloaded from the Open Data Portal of Toronto; keep variables that are of interest
# Author: Yujia Wu
# Date: 29 January 2021
# Contact: yujia.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites and notes:
#  - need to download and save the data to inputs/data by following the steps in the "00_agency_survey_dataimport" R script
#  - the readme.csv file is optional. It provides additional information on the survey and the dataset, but it will
#    will not be used to perform data analysis.


#### Workspace setup ####
library(plyr)
library(tidyverse)


# Read the dataset. 
raw_data <- read.csv('inputs/data/agency_survey_rawdata.csv')


#### Get valid results ####
# Change the data type of the column "Reached.end" to factor because the values do not have numeric meaning
raw_data$Reached.end <- as.factor(raw_data$Reached.end)

# Remove incomplete survey results.
valid_results <-
   raw_data %>% 
   filter(Reached.end == "1")


#### Keep variables related to the impact of COVID-19 on community agencies ####
# 1. Select relevant columns 
impact_raw <- 
   valid_results %>% 
   select(3:17) # we know these are the columns we want by looking at the dataset and the readme file

# 2. Rename the variables because the original titles are too long
impact <-
   impact_raw %>% 
   rename(close_down_adjust_services = X1.1..Had.to.temporarily.close.down.or.adjust.services,
          moved_online = X1.2..Moved.program.and.service.delivery.online,
          increased_hours = X1.3..Had.to.increase.hours.due.to.increased.demand.for.programs.and.services,
          remained_closed = X1.4..Remained.closed.and.unable.to.offer.any.programs.or.services,
          lost_funding = X1.5..Lost.funding.from.program.partners.or.donors,
          lost_revenue = X1.6..Lost.revenue.from.user.fees,
          reduce_staff_hours = X1.7..Had.to.reduce.staff.work.hours,
          laid_off_employees = X1.8..Had.to.lay.off.employees.due.to.financial.constraints,
          hired_more_staff = X1.9..Hired.additional.staff,
          lost_volunteers = X1.10..Lost.volunteers,
          employees_covid = X1.11..Had.employees.that.contracted.COVID.19,
          clients_covid = X1.12..Had.clients.that.contracted.COVID.19,
          new_partnerships = X1.13..Developed.new.partnerships.to.continue.to.deliver.programs.and.services,
          applied_emergency_wage = X1.14..Had.to.apply.to.the.Canada.Emergency.Wage.Subsidy..CEWS..to.maintain.staffing.levels,
          gov_support_ineligible = X1.15..Ineligible.for.federal.or.provincial.supports..e.g..Canada.Emergency.Wage.Subsidy..Canada.Emergency.Business.account.
          )

# 3. Replace NA values with 0s; Change data type
impact[is.na(impact)] <- 0

impact <- impact %>% mutate_if(is.numeric, as.factor)

# 4. Count the frequency of each type of impact voted by the respondents
# inspired by code on https://sarahleejane.github.io/learning/r/2014/09/15/frequency-of-a-variable-per-column-with-R.html
impact_table <- ldply(impact, function(c) sum(c=="1"))

# 5. Rename the variables in impact_table because they are not informative 
impact_table <-
   impact_table %>% 
   dplyr::rename(impact_types = .id, frequency = V1)



#### Keep variables related to the support required by community agencies for the second wave of COVID-19 ####

# 1. Select relevant columns 
sec_support_raw <-
   valid_results %>% 
   select(74:83) # we know these are the columns we want by looking at the dataset and the readme file

# 2. Rename the variables because the original titles are too long
sec_support <-
   sec_support_raw %>% 
   dplyr::rename(health_guide = X6.1..Public.health.guidance.and.information.about.COVID.19,
          workplace_modif = X6.2..Workplace.modification.supports..e.g..plexiglass.barriers.,
          PPE = X6.3..Non.medical.cloth.masks.or.personal.protective.equipment..PPE.,
          tech_support = X6.4..Technology.supports..e.g..devices..remote.meeting.technology.,
          funding_stab_flex = X6.5..Funding.stabilization.or.flexibility,
          add_funding = X6.6..Additional.funding,
          rent_morg_support = X6.7..Rent.or.mortgage.supports,
          financial_support = X6.8..Financial.supports.for.businesses.and.agencies..e.g..wage.subsidies..tax.relief.,
          larger_space = X6.9..Access.to.larger.space.to.accommodate.physical.distancing.requirements,
          comm_coordntn = X6.10..Ongoing.community.coordination.support..e.g..City.United.Way.Community.Coordination.Plan.,
          )

# 3. Replace NA values with 0s; Change data type
sec_support[is.na(sec_support)] <- 0

sec_support <- sec_support %>% mutate_if(is.numeric, as.factor)

# 4. Count the frequency of each type of support voted by the respondents
support_table <- ldply(sec_support, function(c) sum(c=="1"))

# 5. Rename the variables in support_table because they are not informative
support_table <-
   support_table %>% 
   dplyr::rename(support_types = .id, frequency = V1)
