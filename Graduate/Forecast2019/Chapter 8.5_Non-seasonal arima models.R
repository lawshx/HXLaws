# Chapter 8 ARIMA models
library(fpp2) # Load fpp2 package
# install.packages("tseries")
library(tseries)
library(urca)
############################################################
# 8.5 Non-seasonal ARIMA models
############################################################

# We will work with consumption time series from the 'uschange' data set

uschange_cons <- uschange[,"Consumption"] # extract consumption time series.

uschange_cons %>%
  autoplot() + # use US consumption expenditure variable
  xlab("Year") + 
  ylab("Quarterly percentage change")

# The following R code was used to select a model automatically.

(fit <- auto.arima(uschange_cons, seasonal = FALSE)) # We will consider seasonal models next, for now turn it off.

# This function picked an ARIMA(1, 0, 3) model: AR(1), I(0), and MA(3) ; go to class notes
# c  = 0.307

# Forecasts from the model above

fit %>% 
  forecast(h = 10) # This will give you forecast for next 10 quarters

# Figure 8.8: Forecasts of quarterly percentage changes in US consumption expenditure. 

fit %>% 
  forecast(h = 10) %>% # Forecaste 10 periods ahead
  autoplot(include = 80) # Include data for last 80 past observations

#---------------------------------------------------
# How to pick p and q in ARIMA model?

# Figure 8.9: ACF of quarterly percentage change in US consumption.

ggAcf(uschange_cons, main = "ACF for consumption series")

# Figure 8.10: PACF of quarterly percentage change in US consumption. 

ggPacf(uschange_cons, main = "PACF for consumption series")

# The pattern in the first three spikes is what we would expect from an ARIMA(3,0,0), as the PACF tends to decrease.

(fit2 <- Arima(uschange_cons, order = c(3,0,0)))

# This model is actually slightly better than the model identified by auto.arima()
# AICc value of 340.6 compared to 342.08

# The auto.arima() function did not find this model because it does not consider all possible models in its search. 
# The default procedure uses some approximations to speed up the search. These approximations can be avoided with the 
# argument approximation = FALSE. It is possible that the minimum AICc model will not be found due to these approximations, 
# or because of the use of a stepwise procedure. A much larger set of models will be searched if the argument stepwise = FALSE is used.

(fit3 <- auto.arima(uschange_cons, 
                    seasonal = FALSE,  # We will consider seansoanl arima models next. 
                    stepwise = FALSE, 
                    approximation = FALSE)) # 

# This time, auto.arima() has found the same model that we guessed from the ACF and PACF plots.
