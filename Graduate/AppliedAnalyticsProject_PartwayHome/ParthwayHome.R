setwd("C:/Users/lawsh/Source/Repos/HXLaws/Graduate/AppliedAnalyticsProject_PartwayHome")
library(readxl)
library(stringr)
library(lubridate)
library(ggplot2)
the_data <- read_excel("pwh_prelim_data_20161108.xlsx")

#Let's look at the data and find the variables needed to explore for age, month of birth, and 
#distance from home
View(the_data)
colnames(the_data)

#making Month of Birth and Age variables
the_data$dob <- ymd(the_data$dob)
mob <- month(the_data$dob)
age <- floor(difftime(ymd("2016-12-01"), the_data$dob, units = "weeks")/52)


#need to use inst and res variables to recreate "distance from home" variable

usable <- cbind(the_data,mob,age)


hist(usable$mob)
hist(as.numeric(usable$age))