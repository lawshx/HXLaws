#Notes 18 Oct 2018

#import Copy_of+mba5230_ICE_34_mi....

OLS <- lm(daily_download ~ rank + age + pageview + price + rating + raters + filesize_kb + everyone_dummy + freeversion_dummy, data = Copy_of_mba5230_ICE_34_missing_value_handling_and_data_cleansing2)
summary(OLS)
library("lmtest", "car", "tseries")

bptest(OLS)
dwtest(OLS)
vif(OLS)
jarque.bera.test(OLS$residuals)
  
library("foreign", "sandwich")
coeftest(OLS, vcov = vcovHC(OLS, "HC1"))
library("nlme")
GLS<-gls(daily_download ~ rank + age + pageview + price + rating + raters + filesize_kb + everyone_dummy + freeversion_dummy, 
         correlation = corAR1(), method = "ML", data = Copy_of_mba5230_ICE_34_missing_value_handling_and_data_cleansing2, 
         na.action = na.exclude)
summary(GLS)

LR<-glm(everyone_dummy ~ rank + age + pageview + price + rating + raters + filesize_kb + freeversion_dummy, 
        family = "binomial", data = Copy_of_mba5230_ICE_34_missing_value_handling_and_data_cleansing2)
summary(LR)