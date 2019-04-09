# Chapter 8 ARIMA models
library(fpp2) # Load fpp2 package
# install.packages("tseries")
library(tseries)
library(urca)
################################################################################################
# Sec 8.7 ARIMA modelling in R

# Example: Seasonally adjusted electrical equipment orders

# Figure 8.12: Seasonally adjusted electrical equipment orders index in the Euro area. 
elecequip %>% 
  stl(s.window = 'periodic') %>% 
  seasadj() -> eeadj
autoplot(eeadj)

eeadj %>%
  adf.test() # Fail to reject the null hypothesis that this series is a non-stationary series.

eeadj %>%
  ur.kpss() %>% # Reject the null hypothesis that this series is stationary.
  summary()

# estimates the number of differences required to make a given time series stationary.

eeadj %>%
  ndiffs() 

# Figure 8.13: Time plot and ACF and PACF plots for the differenced seasonally adjusted electrical equipment data. 

eeadj %>% 
  diff() %>% # First difference series
  ggtsdisplay(main = "") # This function will show ACF and PACF.

# ACF decays exponentialy, and there is a significant spike in PACF at lag 3. We will use ARIMA(3, 1, 0) model

# Try difference models

fit <- Arima(eeadj, order = c(3,1,0))
summary(fit)
fit$aicc # This will show you AICc for this model

fit <- Arima(eeadj, order = c(4,1,0))
summary(fit)

fit <- Arima(eeadj, order = c(2,1,0))
summary(fit)

fit <- Arima(eeadj, order = c(3,1,1))
summary(fit)

# ARIMA(3,1,1) has a slightly smaller AICc value

checkresiduals(fit)

autoplot(forecast(fit))

autoplot(fit)