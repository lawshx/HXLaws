library(fpp2) # Load fpp2 package
################################################################################################
# Sec 3.1: Simple Forecasting Methods

#Figure 3.1
beer2 <- window(ausbeer, start = 1992, end = c(2007, 4))      # We will use 'aubeer' data set; quarterly beer production data.

# Explore your data set. We will work with 'beer2' data set.
summary(beer2)                                                # notice there are three timer series in this data set.
head(beer2)                                                   # first 6 observations of the data set.
tail(beer2)                                                   # last 6 observations of the data set.

# Forecasting using average method
beer2 %>%
  autoplot() +
  forecast::autolayer(meanf(beer2, h = 11)$mean, series = "Mean") +
  ggtitle("Forecast for Quarterly Beer Production") +
  xlab("Year") + ylab("Megalitres") +
  guides(colour = guide_legend(title = "Forecast")) # Name your legend

#  Forecasting using naive method
beer2 %>%
  autoplot() +
  forecast::autolayer(naive(beer2, h = 11)$mean, series = "Naive") +
  ggtitle("Forecast for Quarterly Beer Production") +
  xlab("Year") + ylab("Megalitres") +
  guides(colour = guide_legend(title = "Forecast")) # Name your legend

#  Forecasting using seasonal naive method
beer2 %>%
  autoplot() +
  forecast::autolayer(snaive(beer2, h = 11)$mean, series = "Seanonal Naive") +
  ggtitle("Forecast for Quarterly Beer Production") +
  xlab("Year") + ylab("Megalitres") +
  guides(colour = guide_legend(title = "Forecast")) # Name your legend
################################################################################################
# Explore your data set. We will work with 'goog200' data set; google daily closing stock price
summary(goog)         # notice there are three timer series in this data set.
head(goog)            # first 6 observations of the data set.
tail(goog)            # last 6 observations of the data set.

# Extract data for first 200 days
goog200 <- window(goog, start = 1, end = 200)

#Figure 3.2
goog200 %>%
  autoplot() +
  forecast::autolayer(meanf(goog200, h = 40), PI= FALSE, series = "Mean") +
  forecast::autolayer(rwf(goog200, h = 40), PI= FALSE, series = "Naive") +
  forecast::autolayer(rwf(goog200, h = 40, drift = TRUE), PI= FALSE, series = "Drift") +
  ggtitle("Google Stock Forecast") +
  xlab("Day") + ylab("Closing Price (US $)") +
  guides(colour = guide_legend(title = "Forecast")) # Name your legend
################################################################################################
# Section 3.3: Residual diagnostics

goog200 <- window(goog, start = 1, end = 200)   # This is our training data set.

# Figure 3.4: The daily Google stock price to 6 Dec 2013. 
goog200 %>%
  autoplot() + 
  xlab("Day") + 
  ylab("Closing Price (US$)") +
  ggtitle("Google Stock (daily ending 6 December 2013)")

# Figure 3.5: Residuals from forecasting the Google stock price using the naive method.
res <- goog200 %>%  # We want to calculate residuals of 'goog200' data.
  naive() %>%       # Apply naive forecast method on 'goog200' data.
  residuals()       # Calculate the residuals of naive forecast.

res %>%
  autoplot() +      # Autoplot residuals of naive forecast
  xlab("Day") + 
  ylab("") +
  ggtitle("Residuals from naive method")

# Figure 3.6: Histogram of the residuals from the naïve method 
res %>%
  gghistogram() +   # Plot histogram of naive forecast 'goog2000'
  ggtitle("Histogram of residuals")

# Figure 3.7: ACF of the residuals from the naïve method
res %>%
  ggAcf() +         # Plot ACF of naive forecast 'goog2000'
  ggtitle("ACF of residuals")

# Portmanteau tests for autocorrelation

# Box-Pierce test
Box.test(res, lag=10, fitdf=0)

# Box-Ljung test
Box.test(res,lag=10, fitdf=0, type="Lj")

# All of these methods for checking residuals are conveniently packaged into one R function
checkresiduals(naive(goog200))
# These results reveal the following
# 1- The residual are uncorrelated (iid or white noise); p-value for Ljun box test is large.
# ACF plot also shows the same story.
# 2- The time plot of residual is close to zero (graph 1)
# 3- The time plot of residual exhibits a constact variance, with one anomoly (graph 1)
# 4- The histogram reveals a constant varianc and the a little too long right tail.
# Overall evidence suggests that naive method works fine in this case.

# Can you perform the same analysis to the other two forecasting methods and check residual properties?
################################################################################################
# Section 3.4: Forecast Accuracy

# Figure 3.8 (Seasonal Data)
beer2 <- window(ausbeer, start = 1992, end = c(2007,4)) # Extract training data from 1992-2007, name it 'beer2'

# Forcast for next 10 periods using 'beer2' data and average method
fc_average <- beer2 %>%
  meanf(h = 10)

# Forcast for next 10 periods using 'beer2' data and naive method
fc_naive <- beer2 %>%
  rwf(h = 10)

# Forcast for next 10 periods using 'beer2' data and seanonal naive method
fc_snaive <- beer2 %>%
  snaive(h = 10)

autoplot(window(ausbeer, start = 1992)) +                 # Plot the original data set 1992-2010-Q2
  autolayer(fc_average$mean, series = "Mean") +           # Add average forecast on the plot
  autolayer(fc_naive$mean, series = "Naive") +            # Add naive forecast on the plot
  autolayer(fc_snaive$mean, series = "Seasonal naïve") +  # Add seasonal naive forecast on the plot
  xlab("Year") + ylab("Megalitres") +
  ggtitle("Forecasts for quarterly beer production") +
  guides(colour = guide_legend(title = "Forecast"))

beer3 <- window(ausbeer, start=2008)                      # beer3 is our test data set
accuracy(fc_average, beer3)                               # Test accuracy of average method on the test data set.
accuracy(fc_naive, beer3)                                 # Test accuracy of naive method on the test data set.
accuracy(fc_snaive, beer3)                                # Test accuracy of seasonal naive method on the test data set.

# Remeber the aim is to find the method which minimizes the forecast error. 
# It is obvious that seasonal naive is the best method here.
# ------------------------------------------------------------------
# Figure 3.9 (Non-seasonal Data)

goog200 <- window(goog, start = 1, end = 200)             # Extract data for first 200 days as a training data set

fc_average <- goog200 %>%
  meanf(h = 40)                                           # Forcast for next 40 periods using 'goog200' data and average method

fc_naive <- goog200 %>%
  rwf(h = 40)                                             # Forcast for next 40 periods using 'goog200' data and naive method

fc_drift <- goog200 %>%
  rwf(h = 40, drift = TRUE)                               # Forcast for next 40 periods using 'goog200' data and drift method

autoplot(subset(goog, end = 240)) +                       # Plot the original data set 1992-2010-Q2
  autolayer(fc_average, PI=FALSE, series = "Mean") +      # Add average forecast on the plot
  autolayer(fc_naive, PI=FALSE, series = "Naïve") +       # Add naive forecast on the plot
  autolayer(fc_drift, PI=FALSE, series = "Drift") +       # Add drift forecast on the plot
  xlab("Day") + ylab("Closing Price (US$)") +
  ggtitle("Google stock price (daily ending 6 Dec 13)") +
  guides(colour=guide_legend(title="Forecast"))

googtest <- window(goog, start=201, end=240)              # googtest is our test data set
accuracy(fc_average, googtest)                            # Test accuracy of average method on the test data set.
accuracy(fc_naive, googtest)                              # Test accuracy of naive method on the test data set.
accuracy(fc_drift, googtest)                              # Test accuracy of drift method on the test data set.

# Remeber the aim is to find the method which minimizes the forecast error. 
# Drift method is the best method here.
# ------------------------------------------------------------------
# Time series cross-validation
goog200 <- window(goog, start = 1, end = 200)             # Extract data for first 200 days as a training data set

e <- goog200 %>%
  tsCV(rwf, drift = TRUE, h = 1)      

mean(e^2, na.rm = TRUE) %>%
  sqrt()
# RMSE 6.279947

goog200 %>% 
  rwf(drift = TRUE) %>% 
  residuals() -> res

res^2 %>% 
  mean(na.rm = TRUE) %>% 
  sqrt()
# RMSE 6.215151

# As expected, the RMSE from the residuals is smaller, 
# as the corresponding "forecasts" are based on a model fitted to the entire data set, 
# rather than being true forecasts.

# Example :  using tsCV()
autoplot(goog)
# The code below evaluates the forecasting performance of 1- to 8-step-ahead naïve forecasts with tsCV, 
# using MSE as the forecast error measure. The plot shows that the forecast error increases 
# as the forecast horizon increases, as we would expect.


goog %>%
  tsCV(forecastfunction=naive, h = 8) -> as.data.frame(e)

mse <- colMeans(e^2, na.rm = TRUE)  # Compute the MSE values and remove missing values

data.frame(h = 1:8, MSE = mse) %>%  # Plot the MSE values against the forecast horizon
  ggplot(aes(x = h, y = MSE)) + geom_point()


e <- as.data.frame(tsCV(goog, forecastfunction=naive, h=8))
# Compute the MSE values and remove missing values
mse <-colMeans(e^2, na.rm = T)
# Plot the MSE values against the forecast horizon
data.frame(h = 1:8, MSE = mse) %>%
  ggplot(aes(x = h, y = MSE)) + geom_point()

################################################################################################
# Sec 3.5 Prediction intervals
goog200 %>%   # Use this data to forecast
  naive()     # Give prediction interval

goog200 %>%   # Use this data to forecast
  naive() %>% # Give prediction interval
  autoplot()  # Plot the above prediction interval
