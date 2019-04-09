# Chapter 8 ARIMA models
library(fpp2) # Load fpp2 package
# install.packages("tseries")
library(tseries)
library(urca)
################################################################################################
# 8.9 Seasonal ARIMA models
################################################################################################
# Example: European quarterly retail trade
# We will describe the seasonal ARIMA modelling procedure using quarterly 
# European retail trade data from 1996 to 2011.

autoplot(euretail) + 
  ylab("Retail index") + 
  xlab("Year")

# check how many differences are required to make series stationary.
ndiffs(euretail) # This is an I(2) series
nsdiffs(euretail) # D = 1

# The data are clearly non-stationary, with some seasonality, so we will first take a seasonal difference. 
euretail %>% 
  diff(lag = 4) %>% # Difference at lag 4
  ggtsdisplay()

# It appears to be non-stationary, so we take an additional first difference
euretail %>% 
  diff(lag = 4) %>% # seasonal difference
  diff() %>% # first difference
  ggtsdisplay()

# The significant spike at lag 1 in the ACF suggests a non-seasonal MA(1) component (go to class notes)
# and the significant spike at lag 4 in the ACF suggests a seasonal MA(1) component (go to class notes)
# Consequently, we begin with an ARIMA(0,1,1)(0,1,1)4 model, 
# indicating a first and seasonal difference, and non-seasonal and seasonal MA(1) components.

euretail %>%
  Arima(order=c(0,1,1), seasonal=c(0,1,1)) %>%
  residuals() %>%
  ggtsdisplay()

# Both the ACF and PACF show significant spikes at lag 2, and almost significant spikes at lag 3, 
# indicating that some additional non-seasonal terms need to be included in the model.

fit3 <- Arima(euretail, order=c(0,1,3), seasonal=c(0,1,1))
checkresiduals(fit3)

fit3 %>% 
  forecast(h = 12) %>% 
  autoplot()


# We could have used auto.arima()
auto.arima(euretail)

# Note that auto.arima may select a different model (with a larger AICc value). 
# auto.arima() takes some short-cuts in order to speed up the computation, 
# and will not always give the best model. The short-cuts can be turned off, 
# and then it will sometimes return a different model.

# If stepwise	= TRUE, the function will do stepwise selection (faster). 
# Otherwise, it searches over all models. Non-stepwise selection can be very slow, especially for seasonal models.

# approximation, If TRUE, estimation is via conditional sums of squares and the information criteria used for model selection are approximated. 
# The final model is still computed using maximum likelihood estimation. 
# Approximation should be used for long time series or a high seasonal period to avoid excessive computation times.

auto.arima(euretail, stepwise=FALSE, approximation=FALSE)


# ---------------------
# Example 2: Corticosteroid drug sales in Australia

# We will try to forecast monthly corticosteroid drug sales in Australia. 

head(h02)

h02 %>%
  autoplot()

lh02 <- log(h02)

cbind("H02 sales (million scripts)" = h02,
      "Log H02 sales"=lh02) %>%
  autoplot(facets=TRUE) + xlab("Year") + ylab("")

# The data are strongly seasonal and obviously non-stationary, so seasonal differencing will be used.

lh02 %>% diff(lag = 12) %>%
  ggtsdisplay(xlab = "Year",
              main = "Seasonally differenced H02 scripts")

# there are spikes in the PACF at lags 12 and 24, but nothing at seasonal lags in the ACF. 
# This may be suggestive of a seasonal AR(2) term.
# In the non-seasonal lags, there are three significant spikes in the PACF, suggesting a possible AR(3) term.
# Consequently, this initial analysis suggests that a possible model for these data is an ARIMA(3,0,0)(2,1,0)12. 

# We fit this model, along with some variations on it, and compute the AICc. 
# Of these models, the best is the ARIMA(3,0,1)(0,1,2)12 model (i.e., it has the smallest AICc value).

(fit <- Arima(h02, 
              order = c(3,0,1), 
              seasonal = c(0,1,2),
              lambda = 0)) # BoxCox transformation

checkresiduals(fit, lag=36)


# Test set evaluation:

#We fit the models using data from July 1991 to June 2006, and forecast the script sales for July 2006 - June 2008.
# In practice, we would normally use the best model we could find, even if it did not pass all of the tests.

h02 %>%
  Arima(order = c(3,0,1), seasonal=c(0,1,2), lambda=0) %>%
  forecast() %>%
  autoplot() +
  ylab("H02 sales (million scripts)") + xlab("Year")

h02 %>%
  auto.arima(lambda=0) %>%
  forecast() %>%
  autoplot() +
  ylab("H02 sales (million scripts)") + xlab("Year")



