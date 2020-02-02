library(dplyr)
library(readr)
PiracyData <- read_csv("mba5230_ app piracy data_ classification tree.csv")

#make sure categorical data are factors not numeric
PiracyData$pirated <-as.factor(PiracyData$pirated)
PiracyData$free <-as.factor(PiracyData$free)
PiracyData$game <-as.factor(PiracyData$game)
#Divide up data
train <- sample_frac(PiracyData, 0.7)
sid<-as.numeric(rownames(train))
validate <- PiracyData[-sid,]

library(party)
fm<-ctree(pirated ~ rank + free + game + ln_price + days_in_rankinglist + 
            fivestars + onestar + filesize_MB, 
          data = train)
plot(fm, terminal_panel = node_terminal)
plot(fm, terminal_panel = node_barplot)


#pruning the tree
plot(ctree(pirated ~ rank + free + game + ln_price + days_in_rankinglist +
             fivestars + onestar + filesize_MB,
           data = train,
         controls = ctree_control(mincriterion = 0.99, minsplit = 500)),
         terminal_panel = node_terminal)



#now to test the model
vfm <- predict(fm)
confusion_matrix<-table(vfm, train$pirated)
confusion_matrix[1]
confusion_matrix[2]
confusion_matrix[3]

#miclassification rate:
(confusion_matrix[2]+confusion_matrix[4])/(confusion_matrix[1]+confusion_matrix[2]+confusion_matrix[3]+confusion_matrix[4])
#accuracy
1-(confusion_matrix[2]+confusion_matrix[4])/(confusion_matrix[1]+confusion_matrix[2]+confusion_matrix[3]+confusion_matrix[4])

vfm<-predict(fm, newdata = validate)
table(vfm,validate$pirated)

(confusion_matrix[2]+confusion_matrix[4])/(confusion_matrix[1]+confusion_matrix[2]+confusion_matrix[3]+confusion_matrix[4])
1-(confusion_matrix[2]+confusion_matrix[4])/(confusion_matrix[1]+confusion_matrix[2]+confusion_matrix[3]+confusion_matrix[4])







######################################################
library(readxl)
ICE<- read_excel("Copy of mba5230_ ICE_ 34_ missing value handling and data cleansing2(1).xlsx")
ICE$freeversion_dummy <- as.factor(ICE$freeversion_dummy)
ICE$everyone_dummy <- as.factor(ICE$everyone_dummy)

train <- sample_frac(ICE, 0.7)
sid<-as.numeric(rownames(train))
validate <- ICE[-sid,]

library(party)
fm<-ctree(daily_download ~ rank + raters + freeversion_dummy, 
          data = train)
plot(fm, terminal_panel = node_terminal)


plot(ctree(daily_download ~ rank + raters + freeversion_dummy,
           data = train,
           controls = ctree_control(mincriterion = 0.99, minsplit = 500)),
     terminal_panel = node_terminal)

accuracy_train <-predict(fm, train)
RMSE.train<-sqrt(mean((accuracy_train - train$daily_download)^2))
RMSE.train

accuracy_validate <-predict(fm, validate)
RMSE.validate<-sqrt(mean((accuracy_validate - validate$daily_download)^2,na.rm = TRUE))
RMSE.validate

abs((RMSE.train - RMSE.validate)/(RMSE.validate+RMSE.train))
