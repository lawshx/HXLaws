# Chapter 8 ARIMA models
library(fpp2) # Load fpp2 package
# install.packages("tseries")
library(tseries)
library(urca)
############################################################
# 8.1 Stationarity and differencing
############################################################

# Example 1

x <- rnorm(1000)  # no unit-root i.e. stationary

x %>%
  adf.test()

y <- diffinv(x)   # contains a unit-root i.e. non-stationary

y %>%
  adf.test()

# KPSS test 

x <- rnorm(1000)  # is level stationary
x %>%
  ur.kpss() %>%
  summary()

y <- cumsum(x)  # has unit root
y %>%
  ur.kpss() %>%
  summary()


# Example 2:  

goog200 <- window(goog, start = 1, end = 200) # Use google stock prices data

goog200 %>%
  Acf() # ACF decays slowly; first evidence that this is a non-stationary series

goog200 %>%
  adf.test() # Fail to reject the null hypothesis that this series is non-stationary series.

goog200 %>%
  ur.kpss() %>%
  summary() # Reject null hypothesis of stationarity. (H0 is different in KPSS than ADF test)

goog200 %>%
  Box.test(lag=10, type="Ljung-Box") #  # Reject null hypothesis of series being white noise (This is a very strong test, use ADF or KPSS instead.)

# Example 2 : Google conti...

# ndiffs() function estimates the number of differences required to make a given time series stationary.

ndiffs(goog200) # number of differences required to make a this series stationary
nsdiffs(goog200) # number of seasonal differences required to make a this series stationary

# take the first difference of goog200 series and test for stationarity

d_goog200 <- diff(goog200)

d_goog200 %>%
  Acf() # No lag is significantly different than zero; first evidence that this is a stationary series

d_goog200 %>%
  adf.test() # Reject the null hypothesis that this series is non-stationary series.

d_goog200 %>%
  ur.kpss() %>%
  summary() # Fail to reject null hypothesis of stationarity. (H0 is different than for ADF test)

d_goog200 %>%
  Box.test(lag=10, type="Ljung-Box") #  # Fail to reject null hypothesis of series being white noise (This is a very strong test, use ADF or KPSS instead.)

# Example 3: Replicate example 2 for the logged unmelec data (US monthly electricity data)

