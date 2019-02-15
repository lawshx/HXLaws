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
callData1<-cbind(callData1,as.data.frame(str_split_fixed(callData$calltime, "T",2)))
callData1[,44]<-gsub("Z","",callData1[,44])

callData1<-cbind(callData1,as.data.frame(str_split_fixed(callData$timeclose, "T",2)))
callData1[,46]<-gsub("Z","",callData1[,46])


#removing calltime and time close columns
callData1<-callData1[,c(-4,-26)]

#renaming new columns
names(callData1)[41]<-"date_Open"
names(callData1)[42]<-"time_Open"
names(callData1)[43]<-"date_Close"
names(callData1)[44]<-"time_Close"

#reordering columns
callData1<-callData1[,c(1:3,41,42,4:24,43,44,25:40)]


#gertrude


#finds all the records that have at least one NA and stores into a dataframe named missingVal for further evaluation/instruction.
#first, target which columns to focus on for missing data because variables like parent_ID will have many NA's but does not hinder the process of creating a prediction model.


#changing all NULL or empty values to NA for easier detection
callData1[callData1==""]<-NA


#observed that cancelled column has 4 factors, False, FALSE, True, TRUE. Changing to only FALSE and TRUE
table(callData1$cancelled)
callData1[,25]<-gsub("False","FALSE",callData1[,25])
callData1[,25]<-gsub("True","TRUE",callData1[,25])
# colnames(callData1)

#Deleting columns gp, ra, and meddilvl
callData1<-callData1[,-c(16,22,23)]

#Eliminating all records where call cancelled is TRUE.
callData1<-callData1[-which(callData1$cancelled==TRUE),]


#noticed UNKNOWN PROBLEM MAN DOWN    UNKNOWN PROBLEM PERSON DOWN as two separate situations. Need clarification before combining.
sort(unique(callData1$nature))
#difference between Diorder Family and Disorder family GPD ONLY?
#difference between hazmat and hazmat - fire only?




#######Convert old categories in NATURE to new categories#################

NATURE<-as.data.frame(unique(callData1$nature))

TheDates<-data.frame(1,min(as.Date(callData1$date_Open)[1]),max(as.Date(callData1$date_Open)[1]))
names(TheDates)<-c("Nature","Start","End")

for (i in 1:dim(NATURE)[1]){
  a<-NATURE[i,]
  dd<-subset(callData1, callData1$nature==a)
  ee<-data.frame(a,min(as.Date(dd$date_Open)),max(as.Date(dd$date_Open)))
  names(ee)<-names(TheDates)
  TheDates<-rbind(TheDates, ee)
  
}

#Comparing suspected old and new categories
TheDates[which(grepl("unknown.*problem",ignore.case = TRUE,TheDates$Nature)),]
TheDates[which(grepl("family",ignore.case = TRUE,TheDates$Nature)),]


#Converting old categories to new
callData1$nature<-gsub("UNKNOWN PROBLEM MAN DOWN","UNKNOWN PROBLEM PERSON DOWN",callData1$nature)
callData1$nature<-gsub("DISORDER FAMILY - GPD ONLY","DISORDER FAMILY",callData1$nature)

# 
# #double checking to see if substitutions where made.
# pp<-as.data.frame(plyr::count(callData1$nature))
# pp[which(grepl("family",ignore.case = T, pp[,1])),]
# pp[which(grepl("unknown.*problem",ignore.case = T, pp[,1])),]


plyr::count(as.Date(TheDates$Start))
plyr::count(as.Date(TheDates$End))


#A way to subset Nature Categories with a specific amount of time used.
subset(TheDates, abs(TheDates$End - TheDates$Start) < (365*2))



#############interesting finds, advise before making changes.##############################
TheDates[which(grepl("active",ignore.case = TRUE,TheDates$Nature)),]
TheDates[which(grepl("911 unknown",ignore.case = TRUE,TheDates$Nature)),] #should there be a difference between 911 unknown and cellular 911 unknown?
TheDates[which(grepl("alarms",ignore.case = TRUE,TheDates$Nature)),] #difference between the two? They are used just about the same amount of time.
#still need clarification on hazmat and hazmat-fire only, there is a about a 2 month gap between them.




#some of the streetonly missing values are actual streets just not filled in, others are highways of stations.
#does this need to be fixed in order to proceed with prediction model?
missingstreets<-subset(callData1,is.na(callData1$streetonly))




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







