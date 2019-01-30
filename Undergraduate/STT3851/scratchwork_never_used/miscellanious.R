



#best subset approach
regfit.full <- regsubsets(price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors + waterfront + view + sqft_above + yr_built + yr_renovated + sqft_living15 + sqft_lot15 + yr_built:yr_renovated + bedrooms:bathrooms + I(view^2), data = housedata, nvmax = 16)

reg.summary <- summary(regfit.full)


# summary(regfit.full)$rsq

par(mfrow = c(2, 2))
plot(reg.summary$rss, xlab = "Number of Variables", ylab = "RSS", type = "l")
plot(reg.summary$adjr2, xlab = "Number of Variables", ylab = " Adjusted RSq", type = "l")
points(which.max(reg.summary$adjr2), reg.summary$adjr2[which.max(reg.summary$adjr2)], col = "red",cex = 2, pch = 20)
plot(reg.summary$cp, xlab = "Number of Variables", ylab = "Cp",
     type ="l")
points(which.min(reg.summary$cp), reg.summary$cp[which.min(reg.summary$cp)], col = "red", cex = 2, pch = 20)
plot(reg.summary$bic, xlab = "Number of Variables", ylab = "BIC",
     type = "l")
points(which.min(reg.summary$bic), reg.summary$bic[which.min(reg.summary$bic)], col = "red", cex = 2, pch = 20)




par(mfrow = c(2, 2))
plot(regfit.full, scale = "r2")
plot(regfit.full, scale = "adjr2")
plot(regfit.full, scale = "Cp")
plot(regfit.full, scale = "bic")

which.min(reg.summary$bic)
coef(regfit.full, which.min(reg.summary$bic))
#according to BIC I should be using (as intercept) bedrooms, bathrooms, sqft_living, view, floors, waterfront, condition, yr_renovated, sqft_lot15, sqft_living15, bed:bathrooms, yr_built:yr_renovated, and 













#forward selection
regfit.fwd <- regsubsets(price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors + waterfront + view + sqft_above + yr_built + yr_renovated + sqft_living15 + sqft_lot15 + yr_built:yr_renovated + bedrooms:bathrooms + I(view^2), data = housedata, nvmax = 16, method = "forward")


reg.summaryfwd <- summary(regfit.fwd)

# summary(regfit.full)$rsq

par(mfrow = c(2, 2))
plot(reg.summaryfwd$rss, xlab = "Number of Variables", ylab = "RSS", type = "l")
plot(reg.summaryfwd$adjr2, xlab = "Number of Variables", ylab = " Adjusted RSq", type = "l")
points(which.max(reg.summaryfwd$adjr2), reg.summaryfwd$adjr2[which.max(reg.summaryfwd$adjr2)], col = "red",cex = 2, pch = 20)
plot(reg.summaryfwd$cp, xlab = "Number of Variables", ylab = "Cp",
     type ="l")
points(which.min(reg.summaryfwd$cp), reg.summaryfwd$cp[which.min(reg.summaryfwd$cp)], col = "red", cex = 2, pch = 20)
plot(reg.summaryfwd$bic, xlab = "Number of Variables", ylab = "BIC",
     type = "l")
points(which.min(reg.summaryfwd$bic), reg.summaryfwd$bic[which.min(reg.summaryfwd$bic)], col = "red", cex = 2, pch = 20)




par(mfrow = c(2, 2))
plot(regfit.fwd, scale = "r2")
plot(regfit.fwd, scale = "adjr2")
plot(regfit.fwd, scale = "Cp")
plot(regfit.fwd, scale = "bic")

which.min(reg.summaryfwd$bic)
coef(regfit.full, which.min(reg.summaryfwd$bic))

#according to BIC I should be using grade, bedrooms, bathrooms, sqft_living, sqft_lots, floors, waterfront, grade, yr_renovated, sqft_lot15, yr_built:yr_renovated






###########backwards selection###############
regfit.bwd <- regsubsets(price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors + waterfront + view + sqft_above + yr_built + yr_renovated + sqft_living15 + sqft_lot15 + yr_built:yr_renovated + bedrooms:bathrooms + I(view^2), data = housedata, nvmax = 16, method = "backward")


reg.summarybwd <- summary(regfit.bwd)

# summary(regfit.full)$rsq

par(mfrow = c(1, 1))
plot(reg.summarybwd$rss, xlab = "Number of Variables", ylab = "RSS", type = "l")
plot(reg.summarybwd$adjr2, xlab = "Number of Variables", ylab = " Adjusted RSq", type = "l")
points(which.max(reg.summarybwd$adjr2), reg.summarybwd$adjr2[which.max(reg.summarybwd$adjr2)], col = "red",cex = 2, pch = 20)
plot(reg.summarybwd$cp, xlab = "Number of Variables", ylab = "Cp",
     type ="l")
points(which.min(reg.summarybwd$cp), reg.summarybwd$cp[which.min(reg.summarybwd$cp)], col = "red", cex = 2, pch = 20)
plot(reg.summarybwd$bic, xlab = "Number of Variables", ylab = "BIC",
     type = "l")
points(which.min(reg.summarybwd$bic), reg.summarybwd$bic[which.min(reg.summarybwd$bic)], col = "red", cex = 2, pch = 20)




par(mfrow = c(1, 1))
plot(regfit.bwd, scale = "r2")
plot(regfit.bwd, scale = "adjr2")
plot(regfit.bwd, scale = "Cp")
plot(regfit.bwd, scale = "bic")

which.min(reg.summarybwd$bic)
coef(regfit.bwd, which.min(reg.summarybwd$bic))




which.min(reg.summarybwd$bic)
which.min(reg.summaryfwd$bic)
which.min(reg.summary$bic)




















# mmmmm <- cv.glm(data = housedata, glmfit = hxlmod2, K = 5)$delta;sqrt(mmmmm)


# 
# 
# 
# 
# 
# training <- sample(19384, 19384*.75)
# 
# mod1<-lm(price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors + waterfront + view + condition + sqft_above + sqft_basement + yr_built + yr_renovated + sqft_living15 + sqft_lot15 + bedrooms:bathrooms + yr_built:yr_renovated, data = housedata, subset = training);summary(mod1)
# 
# #zipcode are very similar to each other
# #all lat and long are all in seattle location
# modfwd<-stepAIC(lm(price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors + waterfront + view + condition + sqft_above + sqft_basement + yr_built + yr_renovated + sqft_living15 + sqft_lot15 + bedrooms:bathrooms + yr_built:yr_renovated + , data = housedata),direction = "forward")
# 
# modbkwd<-stepAIC(lm(price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors + waterfront + view + condition + sqft_above + sqft_basement + yr_built + yr_renovated + sqft_living15 + sqft_lot15 + bedrooms:bathrooms + yr_built:yr_renovated + , data = housedata), direction = "backward")
# 
# 
# summary(modfwd);summary(modbkwd)
# residualPlots(modfwd)
# 
# residualPlots(modbkwd)
# 







# n <- nrow(Auto)
# plot(1:10, type ="n", xlab = "Degree of Polynomial", ylim = c(15, 30),
#      ylab = "Mean Squared Prediction Error")
# MSPE = numeric(10)
# for (j in 1:10){IND <- sample(1:n, size = floor(n/2), replace = FALSE)
# train <- Auto[IND, ]
# test <- Auto[-IND, ]
# for(i in 1:10){
#   mod <- lm(mpg ~ poly(horsepower, i), data = train)
#   pred <- predict(mod, newdata = test)
#   MSPE[i] <- mean((test$mpg - pred)^2)
# }
# lines(1:10, MSPE, col = j)
# points(1:10, MSPE, col = j, pch = 19)
# }