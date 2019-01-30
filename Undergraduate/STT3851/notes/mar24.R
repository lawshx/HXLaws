#mar24

library(PASWR2)

HSWRESTLER

n <- nrow(HSWRESTLER)
train <- sample(1:n, floor(0.80 * n), replace = FALSE)
trainSET <- HSWRESTLER[train, ]
testSET <- HSWRESTLER[-train, ]
dim(trainSET)
dim(testSET)


modf <- lm(hwfat ~ abs + triceps, data = trainSET)
yhat <- predict(modf, newdata = testSET)

MSPE <- mean((testSET$hwfat - yhat)^2)
MSPE

#ben got 9.59
#steven got 10.8
#Its going to vary because there's not a lot of data to base this off of.

#########################################
library(ISLR)
n <- nrow(Auto)
plot(1:10, type ="n", xlab = "Degree of Polynomial", ylim = c(15, 30),
     ylab = "Mean Squared Prediction Error")
MSPE = numeric(10)
for (j in 1:10){IND <- sample(1:n, size = floor(n/2), replace = FALSE)
train <- Auto[IND, ]
test <- Auto[-IND, ]
for(i in 1:10){
  mod <- lm(mpg ~ poly(horsepower, i), data = train)
  pred <- predict(mod, newdata = test)
  MSPE[i] <- mean((test$mpg - pred)^2)
}
lines(1:10, MSPE, col = j)
points(1:10, MSPE, col = j, pch = 19)
}

#########################################

set.seed(1)
k <- 8
MSPE <- numeric(k)
folds <- sample(x = 1:k, size = nrow(HSWRESTLER), replace = TRUE)
xtabs(~folds)
sum(xtabs(~folds))
for(j in 1:k){

  modf <- lm(hwfat ~ abs + triceps, data = HSWRESTLER[folds != j, ])
  pred <- predict(modf, newdata = HSWRESTLER[folds ==j, ])
  MSPE[j] <- mean((HSWRESTLER[folds == j, ]$hwfat - pred)^2)
}
MSPE
weighted.mean(MSPE, table(folds)/sum(folds))


########################################the shortcut to the code above

set.seed(1)
library(boot)
glm.fit <- glm(hwfat ~ abs + triceps, data = HSWRESTLER)
cv.err <- cv.glm(data = HSWRESTLER, glmfit = glm.fit, K = 8)$delta[1]
cv.err
#This is LOOCV

#LOOCV has smaller  than the K CV










