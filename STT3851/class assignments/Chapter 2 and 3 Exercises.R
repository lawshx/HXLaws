#Chapter 2 and 3 Exercises
#By Hannah Xiao Si Laws
library(MASS)

Credit <- read.csv("http://www-bcf.usc.edu/~gareth/ISL/Credit.csv")

#Create a model that predicts an individuals credit rating (Rating).

head(Credit)
mod1 <- lm(Rating~1, data = Credit);mod1


#Create another model that predicts rating with Limit, Cards, Married, Student, and Education as features.

# mod2 <- lm(Rating~Limit+Education, data = Credit); mod2
# mod3 <- lm(Rating~Limit+Married, data = Credit); mod3
# mod4 <- lm(Rating~Limit+Student, data = Credit); mod4
mod5 <- lm(Rating~Limit+Cards+Married+Student+Education, data = Credit); summary(mod5); car::residualPlots(mod5)
# mod6 <- lm(Rating~Income, data = Credit); mod6

mod.fs <- stepAIC(lm(Rating~Limit + Cards + Married + Student + Education, data = Credit), direction = "forward"); mod.fs; car::vif(mod.fs)
modN <- lm(Rating ~ poly(Limit, 2, raw = TRUE) + poly(Cards, 2, raw = TRUE)+ Married + Student + Education, data = Credit); car::residualPlots(modN); car::vif(modN)


#Use your model to predict the Rating for an individual that has a credit card limit of $6,000, has 4 credit cards, is married, is not a student, and has an undergraduate degree (Education = 16).

predict(modN, newdata = data.frame(Limit = 6000, Cards = 4, Married = "Yes", Student = "No", Education = 16), interval = "pred")
predict(modN, newdata = data.frame(Limit = 6000, Cards = 4, Married = "Yes", Student = "No", Education = 16), interval = "conf")


#Use your model to predict the Rating for an individual that has a credit card limit of $12,000, has 2 credit cards, is married, is not a student, and has an eighth grade education (Education = 8).

predict(modN, newdata = data.frame(Limit = 12000, Cards = 2, Married = "Yes", Student = "No", Education = 8), interval = "pred" )
predict(modN, newdata = data.frame(Limit = 12000, Cards = 2, Married = "Yes", Student = "No", Education = 8), interval = "conf" )


library(PASWR2)

mod <- lm(gpa ~ sat, data = GRADES); mod
stepAIC(mod)

predict(mod, newdata = data.frame(sat = 1300), interval = "conf", level = .9)
predict(mod, newdata = data.frame(sat = 1300), interval = "pred"); car::vif(mod)

GRADES
