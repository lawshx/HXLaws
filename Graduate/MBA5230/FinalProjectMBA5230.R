#MBA5230 final project script
library(readxl)
theData <- read_excel("mba5230_ semester project datasetABSOLUTEFINAL.xlsx")
library("lmtest")
library("car")
library("tseries")
library("foreign")
library("sandwich")
library("nlme")

head(theData)
dimnames(theData)

theData_Discounts<-theData[theData$Discount_dummy == 1,]


# theData$Userscore <- as.numeric(theData$Userscore)




model1 <- lm(Sales ~ Discount_dummy + Owners_Before + `Current Players` + Userscore + Increase, data = theData)
model2 <- lm(Sales ~ `Discount Rate` + `Discount Price` + `Discount Deals` + Owners_Before + `Current Players` + Userscore + Increase, data = theData_Discounts)
summary(model1)
summary(model2)

bptest(model1)
dwtest(model1)
vif(model1)
jarque.bera.test(model1$residuals)

bptest(model2)
dwtest(model2)
vif(model2)
jarque.bera.test(model2$residuals)


#robust OLS
coeftest(model1, vcov = vcovHC(model1, "HC1"))
coeftest(model2, vcov = vcovHC(model2, "HC1"))



gls(Sales ~ Discount_dummy + Owners_Before, correlation = corAR1(), method = "ML",data = theData_Discounts, na.action = na.exclude)

mod1_GLS<-gls(Sales ~ Discount_dummy + Owners_Before + `Current Players` + Userscore + Increase, 
              correlation = corAR1(), method = "ML", 
              data = theData, na.action = na.exclude)

mod2_GLS<-gls(Sales ~ `Discount Rate` + `Discount Price` + `Discount Deals` + Owners_Before + `Current Players` + Userscore + Increase, 
         correlation = corAR1(), method = "ML", data = theData_Discounts, 
         na.action = na.exclude)
summary(mod1_GLS)
summary(mod2_GLS)




mod1_LR<-glm(Sales ~ Discount_dummy + Owners_Before + `Current Players` + Userscore + Increase, 
        family = "binomial", data = theData)
mod2_LR<-glm(Sales ~ `Discount Rate` + `Discount Price` + `Discount Deals` + Owners_Before + `Current Players` + Userscore + Increase,
        family = "binomial", data = theData_Discounts)
summary(mod1_LR)
summary(mod2_LR)


