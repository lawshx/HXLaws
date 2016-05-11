# mar 3 notes

.5-(.95*.2)

site <- "http://www-bcf.usc.edu/~gareth/ISL/Credit.csv"
Credit <- read.csv (file = site)
str(Credit)

ModEthnic <- lm(Balance ~ Ethnicity, data = Credit);summary(ModEthnic)

predict(ModEthnic, newdata = data.frame(Ethnicity = "Asian"))
predict(ModEthnic, newdata = data.frame(Ethnicity = "African American"))



site1 <- "http://www-bcf.usc.edu/~gareth/ISL/Advertising.csv"
Advertising <- read.csv(file = site1)
modSales <- lm(Sales ~ TV + Radio + TV:Radio, data = Advertising);summary(modSales);coef(modSales)

predict(modSales, newdata = data.frame(TV=50, Radio =1))
predict(modSales, newdata = data.frame(TV = 250, Radio = 1))


# 
# regression on one predictor and a regression on many other predictores or features.  just because you add more, doesnt make that one predictor more precise
# 
# correlations with variables, different models with fs and be
# no correlation, fs and be would be the same
# 
# more var, not going to necesar explain one variable^2


