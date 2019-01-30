# f<-function(x){
#   x^2
# }
# 
# f(3)
# 
# ff<-function(x,m,dd){
#   (1/sqrt(2*pi*(dd^2))*(exp(-(x-m)^2/(2*(dd^2)))))
# }
# 
# ff()


f <- function(x){
  x^2
}
curve(f, -1, 2)
# P(0 < X < 1) = ?
integrate(f, 0, 1)

# X ~ N(100, 10)
MU <- 100
SIGMA <- 10
#
f <- function(x){
  (1/(sqrt(2*pi*SIGMA^2)))*exp(-(x - MU)^2/(2*SIGMA^2))
}

# P(90 < X < 110)
a1 <- integrate(f, 90, 110)$value
a1
a2 <- pnorm(110, MU, SIGMA) - pnorm(90, MU, SIGMA)
a2
a1 == a2
# 
#
# X ~ N(100, 15), find P(80 < X < 105)
g <- function(x, MU = 100, SIGMA = 15){
  (1/(sqrt(2*pi*SIGMA^2)))*exp(-(x - MU)^2/(2*SIGMA^2))
}
integrate(g, 80, 105)
pnorm(105, 100, 15) - pnorm(80, 100, 15)