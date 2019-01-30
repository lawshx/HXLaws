################################################################################################
# Getting started with R
install.packages("fpp2", dependencies = TRUE) # This will install fpp2 along with all the required packages to your machine.

getwd() # working directory folder

# set working directory to a different folder
setwd("~/Forecast2019")

# check working directory
getwd()

################################################################################################
library(fpp2) # Load fpp2 package

# Sect 2.1 ts objects

y <- ts(c(123,39,78,52,110), start = 2012)
y

# another way of doing it
z <- c(123,39,78,52,110) # assign these values to z

y <- ts(z, start = 2012) # pass vector z to y, and we will get the same results.

################################################################################################
# Sec 2.2 Time plots

# Explore 'melsyd' data set
summary(melsyd)
head(melsyd)
tail(melsyd)

# Figure 2.1: Weekly economy passenger load on Ansett Airlines. 
autoplot(melsyd[, "Economy.Class"]) +  # Add a title, x-axis, and y-axis to the graph. Note the '+' sign.
  ggtitle("Economy class passengers: Melbourne-Sydney") +
  xlab("Year") +
  ylab("Thousands")

# or

melsyd_eco <- melsyd[, "Economy.Class"] %>%
  autoplot() +
  ggtitle("Economy class passengers: Melbourne-Sydney") +
  xlab("Year") +
  ylab("Thousands")

# Figure 2.2: Monthly sales of antidiabetic drugs in Australia.
autoplot(a10) +
  ggtitle("Antidiabetic drug sales") +
  ylab("$ million") +
  xlab("Year")


################################################################################################
# Sec 2.4 Seasonal plots

# Figure 2.4: Seasonal plot of monthly antidiabetic drug sales in Australia. 
ggseasonplot(a10, year.labels = TRUE, year.labels.left = TRUE) +
  ylab("$ million") +
  ggtitle("Seasonal plot: antidiabetic drug sales")

# Figure 2.5: Polar seasonal plot of monthly antidiabetic drug sales in Australia. 
ggseasonplot(a10, polar = TRUE) +
  ylab("$ million") +
  ggtitle("Polar seasonal plot: antidiabetic drug sales")
################################################################################################
# Sec 2.5 Seasonal subseries plots

# Figure 2.6: Seasonal subseries plot of monthly antidiabetic drug sales in Australia. 
ggsubseriesplot(a10) +
  ylab("$ million") +
  ggtitle("Seasonal subseries plot: antidiabetic drug sales")
################################################################################################
# Sec 2.6: Scatter Plots
# We want to study reltionship between temperature and demand by plotting one seris against other.

# Explore your data set. We will work with 'elecdemand' data set.
summary(elecdemand) # notice there are three timer series in this data set.
head(elecdemand)    # first 6 observations of the data set.
tail(elecdemand)    # last 6 observations of the data set.

# Figure 2.7: Half hourly electricity demand and temperatures in Victoria, Australia, for 2014. 
elecdemand_temp <- elecdemand[,c("Demand","Temperature")] # Extract demand and temperature columns name them elecdemand_temp

autoplot(elecdemand_temp, facets = TRUE) + # facet = TRUE will plot demand and temperature to two plots. Try 'facet = FALSE'.
  xlab("Year: 2014") + ylab("") +
  ggtitle("Half-hourly electricity demand: Victoria, Australia")


# Figure 2.8: Half-hourly electricity demand plotted against temperature for 2014 in Victoria, Australia.
as.data.frame(elecdemand) %>% # we need as.data.frame(mydata) to convert our 'time series' data into data frame.
  ggplot() + 
  aes(x = Temperature, y = Demand) +  # series to be plotted on x-axis and y-axis
  geom_point()                        # This will plot a point for each observation

# Figure 2.12: A scatterplot matrix of the quarterly visitor nights in five regions of NSW, Australia. 
visnights[, 1:5] %>%
  as.data.frame() %>%
  GGally::ggpairs()


# One more graph
as.data.frame(arrivals) %>%   # we need as.data.frame(mydata) to convert our 'time series' data into data frame.
  GGally:: ggpairs()          # run 'install.packages("GGally")' command to install GGally package for the first time.
################################################################################################
# Section 2.7: Lag plots
beer2 <- window(ausbeer, start = 1992) # creat new data from ausbeer, name it beer2, which starts from 1992
summary(beer2)
head(beer2)
tail(beer2)

acf(beer2, lag.max = 50, plot = FALSE)

acf(beer2, lag.max = 50, plot = T)

# Figure 2.11
beer2 %>%       # Use this data set.
  gglagplot()   # plot lag plots
################################################################################################
# Section 2.8: Autocorrelation

# Figure 2.14: Autocorrelation function of quarterly beer production. 
beer2 %>%
  ggAcf(lag.max = 50) # Use ggAcf(lag.max = n) to graph n lags on ACF

# or

beer2 %>%
  ggAcf() 


# Figure 2.15: Monthly Australian electricity demand from 1980-1995. 
aelec <- window(elec,  start = 1980) # creat a new data set 
autoplot(aelec) + # autoplot it
  xlab("Year") +    # x-axis label = Year
  ylab("GWh")       # y-axis label = GWh

# Figure 2.16: ACF of monthly Australian electricity demand. 
aelec %>%
  ggAcf(lag.max = 48) +
  ggtitle("Australian Electricity Demand (ACF)") 
################################################################################################
# Section 2.9 : White Noise

set.seed(30)        # For replication
y <- ts(rnorm(50))  # time series of 50 random observations
summary(y)
head(y)
tail(y)

# Figure 2.17: A white noise time series.
y %>%                     # Series to be plotted
  autoplot() +            # Plot it
  ggtitle("White Noise")  # Title of the graph

# Figure 2.18: Autocorrelation function for the white noise series. 
y %>%                     # Series to be plotted
  ggAcf() +               # ACF of aboe series
  ggtitle("White Noise (ACF)")

boxplot(y)
################################################################################################
# Ljung-Box test: It is a  statistical test of whether any of a group of autocorrelations of 
# a time series are different from zero. Instead of testing randomness at each distinct lag, 
# it tests the "overall" randomness based on a number of lags.

# H0: The series is i.i.d
# H1: The series exhibits serial correlation
pigs %>%      # Use pigs data set
  Box.test(lag = 24, fitdf = 0, type = "Lj")
# Here we get a very small p-value; reject H0. The series is not white noise. 

# Example 2:
set.seed(3)         # For replication
z <- ts(rnorm(50))  # time series of 50 random observations

z %>%               # Use z data series
  Box.test(lag = 20, fitdf = 0, type = "Lj")
# Here we get a very large p-value i.e. 0.8998; fail to reject H0. The 'z' series is white noise. 
