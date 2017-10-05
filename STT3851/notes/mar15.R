set.seed(123)

y <- rnorm(1000)

x <- rnorm(1000)

plot(y ~ x)

mod <- lm(y~x); summary(mod)

