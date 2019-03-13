library(stringr)
library(plyr)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

getwd()

#creates directory to store CSV files
# dir.create("GuilfordProject2019_CSV")


#reading in the callsForServiceUpdated file, the file path will be different depending on where this file is located on your machine.
callData<-read.csv("callsForServiceUpdated.csv")

#renaming so we don't have to upload the file in to the R environment
#we only need to do this while experimenting with data cleaning techniques
callData1<-callData



#Removes the Z and T in the calltime and timeclose variables
callData1[,4]<-gsub("Z","",callData1[,4])
callData1[,4]<-gsub("T"," ",callData1[,4])

callData1[,26]<-gsub("Z","",callData1[,26])
callData1[,26]<-gsub("T"," ",callData1[,26])


#renaming columns
names(callData1)[4]<-"start_time"
names(callData1)[26]<-"end_time"


#changing all NULL or empty values to NA for easier detection
callData1[callData1==""]<-NA


#observed that cancelled and rptonly columns has 4 factors, False, FALSE, True, TRUE. Changing to boolean TRUE and FALSE
callData1$cancelled <- as.logical(callData1$cancelled)
callData1$rptonly <- as.logical(callData1$rptonly)


#Deleting columns gp, ra, and meddilvl because they have been deemed unimportant in creating a predictive model.
callData1<-callData1[,-c(15,21,22)]

#Eliminating all records where call cancelled is TRUE.
callData1<-callData1[-which(callData1$cancelled==TRUE),]

#Observed similar categories while looking through all within the data.
sort(unique(callData1$nature))




#######Convert old categories in NATURE to new categories#################

NATURE<-data.frame(unique(callData1$nature))

TheDates<-data.frame(Nature = 1,Start = as.Date.character("2017-01-01"),End = as.Date.character("2017-01-01"))

for (i in 1:nrow(NATURE)){
  a<-NATURE[i,]
  dd<-callData1[callData1$nature==a,"start_time"]
  ee<-data.frame(Nature = a,Start = min(dd),End = max(dd))
  TheDates<-rbind(TheDates, ee)
}



#shows how often a date appears in dataset.
plyr::count(as.Date(TheDates$Start))
plyr::count(as.Date(TheDates$End))


#A way to subset Nature Categories with a specific amount of time used.
#This will help to find possible categories that may need to be switched out to newer categories.
subset(TheDates, abs(TheDates$End - TheDates$Start) < (365*2))



#############interesting finds, advise before making changes.##############################
TheDates[which(grepl("unknown.*problem",ignore.case = TRUE,TheDates$Nature)),]
TheDates[which(grepl("family",ignore.case = TRUE,TheDates$Nature)),]
TheDates[which(grepl("active",ignore.case = TRUE,TheDates$Nature)),]
TheDates[which(grepl("911 unknown",ignore.case = TRUE,TheDates$Nature)),] #should there be a difference between 911 unknown and cellular 911 unknown?
TheDates[which(grepl("alarms",ignore.case = TRUE,TheDates$Nature)),] #difference between the two? They are used just about the same amount of time.
#still need clarification on hazmat and hazmat-fire only, there is a about a 2 month gap between them.



#converting older categories to newer ones
callData1$nature<-gsub("UNKNOWN PROBLEM MAN DOWN","UNKNOWN PROBLEM PERSON DOWN",callData1$nature)
callData1$nature<-gsub("DISORDER FAMILY - GPD ONLY","DISORDER FAMILY",callData1$nature)
callData1$nature<-gsub("CELLULAR 911 UNKNOWN","911 UNKNOWN",callData1$nature)
callData1$nature<-gsub("ACTIVE SHOOTER ALARM","ACTIVE SHOOTER",callData1$nature)
callData1$nature<-gsub("ALARMS","OTHER ALARMS / PANIC ALARMS",callData1$nature)




#calculating time duration and dividing by 60 to convert the results to minutes.
dur <- data.frame(duration = difftime((callData1$end_time),(callData1$start_time))/60)

#Combine duration with the dataset and keeping the variable name "duration".
callData1<-cbind(callData1,dur)

#looking at the negative durations
callData1[which(callData1$duration < 0),c("start_time","end_time", "duration")]

#deleting observation since time stamps are at least 3 years apart.
callData1 <- callData1[,-931160]

#keeps track of variables with negative durations before fixing.
neg_times <- which(callData1$duration < 0)


#many of the negative duration times where a mistake between the start and end times being switched.
#solution: switching start and end times so that the duration is positive.

for (i in 1:length(neg_times)) {
  a <- callData1$start_time[neg_times[i]]
  b <- callData1$end_time[neg_times[i]]
  callData1$start_time[neg_times[i]] <- b
  callData1$end_time[neg_times[i]] <- a
  callData1$duration[neg_times[i]]<- difftime((callData1$end_time[neg_times[i]]),(callData1$start_time[neg_times[i]]))/60
}


zero_times <- which(callData1$duration == 0) #there are over 3000 observations that have a call duration time of 0.
table(callData1[zero_times,"agency"]) # this shows that EMS has the most calls with zero duration
# zz<-callData1[which(callData1[zero_times,]$agency=="EMS"),] #closer look into EMS calls with no duration.


#some of the streetonly missing values are actual streets just not filled in, others are highways of stations.
#does this need to be fixed in order to proceed with prediction model?
missingstreets <- callData1[is.na(callData1$streetonly),c("street","streetonly")]

#searching for which streets are soley highways
missingstreets[which(grepl("hwy|i 40|i-40| us",ignore.case = TRUE,missingstreets$street)),]

#filling in streetonly variable with just the street names **needs editings**
missingstreets$streetonly <- gsub("^[0-9]{1,5}\\s([^ ]*.*$)","\\1",missingstreets$street)







##########Looking for Missing Values###############
sort(colSums(is.na(callData1)))



#variables to ignore: ***these have an overwhelming amount of NA's which means either procedures need to change, or these variables are not going to hinder model creation.***
#parent_id, case_id, nature2, meddislvl,district, statbeat, ra, gp, primeunit,firstdisp

#variables to focus on: ***these variables have a relatively smaller number of NA's which could be reason to delete or alter said data points.
#callsource,street,city,nature,priority,service,closedcode
#we will ignore street only
#corresponding column numbers: 5,6,7,11,13,16,22

#collecting all the records where the columns have NA in the aforementioned focus column groups.
missingVal<-callData1[unique (unlist (lapply (callData1[,c(5,6,7,11,13,16,22)], function (x) which (is.na (x))))),]



#gaining a better understanding of which departments have the most missing values.
colSums(is.na(callData1[which(callData1$agency=="ACO"),c(5,6,7,11,13,16,22)]))
colSums(is.na(callData1[which(callData1$agency=="EMS"),c(5,6,7,11,13,16,22)]))
colSums(is.na(callData1[which(callData1$agency=="GCF"),c(5,6,7,11,13,16,22)]))
colSums(is.na(callData1[which(callData1$agency=="GCSD"),c(5,6,7,11,13,16,22)]))



# #suggestions on what to factorize...essentailly what will need dummy variables.
# as.factor(callData1$agency)
# as.factor(callData1$callsource)
# as.factor(callData1$city)
# as.factor(callData1$streetonly)
# as.factor(callData1$nature)
# as.factor(callData1$nature2)
# as.factor(callData1$priority)
# as.factor(callData1$medprior)
# as.factor(callData1$rptonly)
# as.factor(callData1$service)
# as.factor(callData1$district)
# as.factor(callData1$statbeat)
# as.factor(callData1$primeunit)
# as.factor(callData1$closecode)

#############################################MODELLING DATA###################################################### 
# #regression models to be implimented.
# #NOTE: Trying to run these models took too long.
# step(lm( duration ~ agency + callsource + city + streetonly + nature + nature2 + priority + medprior + rptonly + service + district + statbeat + primeunit + closecode + long + lat,data = callData1), direction = "backwards")
# step(lm( duration ~ agency + callsource + city + streetonly + nature + nature2 + priority + medprior + rptonly + service + district + statbeat + primeunit + closecode + long + lat,data = callData1), direction = "forward")



#duration needs to be converted to a number instead of the difference between two times in order to analyze it.
callData1$duration <- as.numeric(callData1$duration)










##################################################################
#separate data by agency
GCSD<-as.data.frame(subset(callData1,callData1$agency=="GCSD"))
ACO<-as.data.frame(subset(callData1,callData1$agency=="ACO"))
EMS<-as.data.frame(subset(callData1,callData1$agency=="EMS"))
GCF<-as.data.frame(subset(callData1,callData1$agency=="GCF"))

#saving those into separate CSV files
write.csv(GCSD,file = "GuilfordProject2019_CSV/GCSD.csv")
write.csv(ACO,file = "GuilfordProject2019_CSV/ACO.csv")
write.csv(EMS,file = "GuilfordProject2019_CSV/EMS.csv")
write.csv(GCF,file = "GuilfordProject2019_CSV/GCF.csv")







