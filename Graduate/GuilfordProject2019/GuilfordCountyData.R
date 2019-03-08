library(stringr)
library(plyr)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

getwd()

#creates directory to store CSV files
dir.create("GuilfordProject2019_CSV")


#reading in the callsForServiceUpdated file, the file path will be different depending on where this file is located on your machine.
callData<-read.csv("callsForServiceUpdated.csv")

#renaming so we don't have to upload the file in to the R environment
#we only need to do this while experimenting with data cleaning techniques
callData1<-callData




#splits the calltime and timeclose columns into date and time columns. In this process, the "T" and "Z" are removed. 
#The calltime and timeclose variables are also removed since these were separated into different columns: date_Open, time_Open, date_Close, time_Close.
#These columns are then reordered to match where calltime and timeclose use to be.

#splitting columns and removing "T" and "Z"
# callData1<-cbind(callData1,as.data.frame(str_split_fixed(callData$calltime, "T",2)))
callData1[,4]<-gsub("Z","",callData1[,4])
callData1[,4]<-gsub("T"," ",callData1[,4])

# callData1<-cbind(callData1,as.data.frame(str_split_fixed(callData$timeclose, "T",2)))
callData1[,26]<-gsub("Z","",callData1[,26])
callData1[,26]<-gsub("T"," ",callData1[,26])


#renaming new columns
names(callData1)[4]<-"start_time"
names(callData1)[26]<-"end_time"


#gertrude


#finds all the records that have at least one NA and stores into a dataframe named missingVal for further evaluation/instruction.
#first, target which columns to focus on for missing data because variables like parent_ID will have many NA's but does not hinder the process of creating a prediction model.


#changing all NULL or empty values to NA for easier detection
callData1[callData1==""]<-NA


#observed that cancelled column has 4 factors, False, FALSE, True, TRUE. Changing to only FALSE and TRUE
table(callData1$cancelled)
callData1[,24]<-gsub("False","FALSE",callData1[,24])
callData1[,24]<-gsub("True","TRUE",callData1[,24])
# colnames(callData1)

#Deleting columns gp, ra, and meddilvl because they have been deemed unimportant in creating a predictive model.
callData1<-callData1[,-c(15,21,22)]

#Eliminating all records where call cancelled is TRUE.
callData1<-callData1[-which(callData1$cancelled==TRUE),]

#Observed similar categories while looking through all within the data.
sort(unique(callData1$nature))




#######Convert old categories in NATURE to new categories#################

NATURE<-as.data.frame(unique(callData1$nature))

TheDates<-data.frame(1,as.Date.character("2017-01-01"),as.Date.character("2017-01-01"))
names(TheDates)<-c("Nature","Start","End")

for (i in 1:dim(NATURE)[1]){
  a<-NATURE[i,]
  dd<-subset(callData1, callData1$nature==a)
  ee<-data.frame(a,min(as.Date(dd$start_time)),max(as.Date(dd$start_time)))
  names(ee)<-names(TheDates)
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
duration <- data.frame(difftime((callData1$end_time),(callData1$start_time))/60)

#Combine duration with the dataset and keeping the variable name "duration".
callData1<-cbind(callData1,duration)
names(callData1)[40]<-"duration"

#looking at the negative durations
callData1[which(duration < 0),c("start_time","end_time", "duration")]

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


#some of the streetonly missing values are actual streets just not filled in, others are highways of stations.
#does this need to be fixed in order to proceed with prediction model?
missingstreets <- callData1[is.na(callData1$streetonly),c("street","streetonly")]

#searching for which streets are soley highways
missingstreets[which(grepl("hwy|i 40|i-40| us",ignore.case = TRUE,missingstreets$street)),]










##########Looking for Missing Values###############
sort(colSums(is.na(callData1)))

#variables to ignore: ***these have an overwhelming amount of NA's which means either procedures need to change, or these variables are not going to hinder model creation.***
#parent_id, case_id, nature2, meddislvl,district, statbeat, ra, gp, primeunit,firstdisp

#variables to focus on: ***these variables have a relatively smaller number of NA's which could be reason to delete or alter said data points.
#callsource,street,city,nature,priority,service,closedcode
#we will ignore street only
#corresponding column numbers: 6,7,8,12,14,17,23

#collecting all the records where the columns have NA in the aforementioned focus column groups.
missingVal<-callData1[unique (unlist (lapply (callData1[,c(6:8,12,14,17,23)], function (x) which (is.na (x))))),]






#############################################MODELLING DATA###################################################### 
# #regression models to be implimented.
# step(lm( duration ~. ,data = callData1), direction = "backwards")
# step(lm( duration ~. ,data = callData1), direction = "forwards")










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







