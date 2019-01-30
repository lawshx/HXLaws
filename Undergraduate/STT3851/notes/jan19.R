set.seed(100)
n<-2000
x<-rnorm(n,120,3)
y<-rnorm(n,100,4)
z<-x-y
mean(z)
sd(z)
hist(z,col="purple",main="This is Hannah L")

pnorm(25,20,5)-pnorm(15,20,5)

#finding the percentage betwen 25 and 15
sum((z<=25&z<=15)/length(z))
mean(z<=25&z<=15)


#now using PAWSR2
library(PASWR2)

X<-CALCULUS$score[CALCULUS$calculus=="Yes"]
Y<-CALCULUS$score[CALCULUS$calculus=="No"]
qqnorm(X)
qqnorm(Y)
xbar<-mean(X)
ybar<-mean(Y)
c(xbar,ybar)
Zobs<-((86.94444-62.61111)-0)/sqrt((25/18)+(144/18))
Zobs #7.941352
pvalue<-pnorm(7.941352,lower.tail=F)
# 1-pnorm(7.941352)

z.test(x=X,y=Y,sigma.x = 5,sigma.y = 12,alternative = "greater")










