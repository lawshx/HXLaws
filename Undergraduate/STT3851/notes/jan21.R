#mean of treatment = 4.4
#(1+10+2+2+7)/5

#mean of placebo = 12

#so....was this efective?

(17+10+2+1+7)/5
#7.4 for treatment

(10+16+7+7+17)/5
#11.4 for treatment

(7+10+10+17+1)/5
#9 for treatment

(16+7+2+10+1)/5
#7.2 for treatment

(10+10+7+1+16)/5
#8.8

(7+10+10+17+7)/5
#10.2

7.4-12

11.4-9
9-5
7.2-7.4
8.8-9.2
10.2-6.2








C<-c(3.6,-2,-0.8,-4,2.8,2,2,5.2,-2,-3.8,-4.2,-4,1.6,7.6,1.4,2.4,4.4,-1.6,-4,2.4,4,-.2,-.4,4,.4,.8,7.6,4.4,-4.6,-4.4,4.8,4.4,4.4,2,4.4,5.2,1.6,4.4,5.6-1.6,0,-7.6,-7.6,2,1.6,4.4,-2.8,5.6,1.6,2.8,-3.2,2,-.4,-1.6,-1.2,1-.6,2,0,1.2,-1.2,2.4,1.6,2.8,3.6,2)
pvalue <- 2/65


# we start out with this
# worms<- c(1,2,2,10,7,16,10,10,7,17)
# index <- sample(10,size = 5,replace = FALSE)
# index
# worms[index]
# mean(worms[index])-mean(worms[-index])



#then create a loop do this calculation multiple times at a much faster speed
R<-10000-1
md<-numeric(R)
worms<- c(1,2,2,10,7,16,10,10,7,17)
for(i in 1:R)
{
  
index <- sample(10,size = 5,replace = FALSE)
md[i]<-mean(worms[index])-mean(worms[-index])

}

md
hist(md)

pvalue<-(sum(md<=-7.6)+1)/(R+1)
pvalue



