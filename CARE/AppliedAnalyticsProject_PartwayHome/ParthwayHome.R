#PWH Statistical Analysis Script
#By Hayden Laws

#setting up R environment with correct packages to run script
setwd("C:/Users/lawsh/Downloads")
library(haven)
library(stringr)
library(lubridate)
library(ggplot2)
library(sqldf) #This allows for use of SQL in R.
library(fastDummies)


#importing the datasets
the_data <- read_sas("data1.sas7bdat", NULL) #main data to perform analysis
the_extra <- read_sas("data2.sas7bdat", NULL) #if time allows repeat analysis on this data


#Let's look at the variable names and find the ones needed to explore for age, month of birth, and 
#distance from home
colnames(the_data)

#They are: DOB, Home_Distance_NC
#We will also need: GENDER, RACE, FLAG_GPA, TRANSFER_CAT, Target_Six_Year_Grad


#making Month of Birth and Age variables
the_data$DOB <- ymd(the_data$DOB) #formatting dates to extract month
mob <- month(the_data$DOB) #extracting month and naming in variable "mob"

#Age is calculated using the last day of the last month of the 2016 year
age <- floor(difftime(ymd("2016-12-31"), the_data$DOB, units = "weeks")/52)


#Combining new variables with the main dataset
usable <- cbind(the_data,mob,age)


#Simple histograms to see distribution of birth month and age respectively.
hist(usable$mob)
hist(as.numeric(usable$age))

#Using SQL to understand what the difference between the two data sets are.
#The extra dataset only looks at students that graduated within a 8 year window.
#The main dataset looks at both 6 and 8 year graduation plans.
sqldf('SELECT * FROM the_data WHERE NEWID IN(
      SELECT NEWID FROM the_data WHERE NEwID NOT IN (SELECT NEwID FROM the_extra))')




#Now looking at the necessary information and making sure that there is no missing data
table(usable$mob)
table(usable$Home_Distance_NC)
table(usable$Target_Six_Year_Grad)
#None of these are adding up to the total number of observations.

na.omit(usable$mob)



#Creating dummy variables

#Birth Month Dummy Variables
#first finding the birth month that appears most frequently in the data set.
#This most frequent month will be "zeroed out" meaning when all dummy variables are 0, they refer to this month. 
sort(table(usable$mob)) # That month is July

mob1<-ifelse(usable$mob==1,1,0)
mob2<-ifelse(usable$mob==2,1,0)
mob3<-ifelse(usable$mob==3,1,0)
mob4<-ifelse(usable$mob==4,1,0)
mob5<-ifelse(usable$mob==5,1,0)
mob6<-ifelse(usable$mob==6,1,0)
mob8<-ifelse(usable$mob==8,1,0)
mob9<-ifelse(usable$mob==9,1,0)
mob10<-ifelse(usable$mob==10,1,0)
mob11<-ifelse(usable$mob==11,1,0)
mob12<-ifelse(usable$mob==12,1,0)
#NOTE: mob7 is not created. mob1-12 are suppose to represent each month. ie) mob1 = jan, mob2 = feb, etc.


#Institution dummy variable AND FLAG_INST
sort(table(usable$FLAG_INST)) # That institution is code 2975
inst1 <- ifelse(usable$FLAG_INST==3981,1,0)
inst2 <- ifelse(usable$FLAG_INST==2926,1,0)
inst3 <- ifelse(usable$FLAG_INST==2907,1,0)
inst4 <- ifelse(usable$FLAG_INST==2986,1,0)
inst5 <- ifelse(usable$FLAG_INST==2954,1,0)
inst6 <- ifelse(usable$FLAG_INST==2950,1,0)
inst7 <- ifelse(usable$FLAG_INST==2928,1,0)
inst8 <- ifelse(usable$FLAG_INST==2974,1,0)
inst9 <- ifelse(usable$FLAG_INST==2981,1,0)
inst10 <- ifelse(usable$FLAG_INST==2905,1,0)
inst11 <- ifelse(usable$FLAG_INST==2906,1,0)
inst12 <- ifelse(usable$FLAG_INST==2984,1,0)
inst13 <- ifelse(usable$FLAG_INST==2972,1,0)
inst14 <- ifelse(usable$FLAG_INST==2976,1,0)
inst15 <- ifelse(usable$FLAG_INST==2923,1,0)


#Making the models
#Target_Six_Year_Grad is the dependent variable

#linear regression models
#all variables, no squared terms
mod <- lm(Target_Six_Year_Grad ~ mob1 + mob2 + mob3 + mob4 + mob5 + mob6 + mob8 + mob9 + mob10 + mob11 + mob12 + 
            Home_Distance_NC + age + GENDER + RACE + FLAG_GPA + TRANSFER_CAT + inst1 + inst2 + inst3 + inst4 + inst5 + inst6 + 
            inst7 + inst8 + inst8 + inst9 + inst10 + inst11 + inst12 + inst13 + inst14 + inst15, na.action = na.exclude,
          data = the_data)
summary(mod)



mod_age2 <- lm(Target_Six_Year_Grad ~ mob1 + mob2 + mob3 + mob4 + mob5 + mob6 + mob8 + mob9 + mob10 + mob11 + mob12 + 
            Home_Distance_NC + age  + (age**2)+ GENDER + RACE + FLAG_GPA + TRANSFER_CAT + inst1 + inst2 + inst3 + inst4 + inst5 +
              inst6 + inst7 + inst8 + inst8 + inst9 + inst10 + inst11 + inst12 + inst13 + inst14 + inst15, 
            na.action = na.exclude, data = the_data)
summary(mod_age2)



mod_distance2 <- lm(Target_Six_Year_Grad ~ mob1 + mob2 + mob3 + mob4 + mob5 + mob6 + mob8 + mob9 + mob10 + mob11 + mob12 + 
            Home_Distance_NC  + (Home_Distance_NC**2) + age + GENDER + RACE + FLAG_GPA + TRANSFER_CAT + inst1 + inst2 + inst3 + 
              inst4 + inst5 + inst6 + inst7 + inst8 + inst8 + inst9 + inst10 + inst11 + inst12 + inst13 + inst14 + inst15, 
            na.action = na.exclude, data = the_data)
summary(mod_distance2)



mod_distance2_age2 <- lm(Target_Six_Year_Grad ~ mob1 + mob2 + mob3 + mob4 + mob5 + mob6 + mob8 + mob9 + mob10 + mob11 + mob12 + 
            Home_Distance_NC  + (Home_Distance_NC**2) + age + (age**2) + GENDER + RACE + FLAG_GPA + TRANSFER_CAT + inst1 + inst2 + 
              inst3 + inst4 + inst5 + inst6 + inst7 + inst8 + inst8 + inst9 + inst10 + inst11 + inst12 + inst13 + inst14 + inst15, 
            na.action = na.exclude, data = the_data)
summary(mod_distance2)










