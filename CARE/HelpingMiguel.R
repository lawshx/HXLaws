x <- as.data.frame(c("M", "K", "J", "L", "I"))
x <- cbind(x,c(1,2,3,4,5))

translate1 <- function(y,z){
  y[,z]<- gsub("M","Miguel",y[,z])
  y[,z]<- gsub("K","Kevin",y[,z])
  y[,z]<- gsub("J","Jelly",y[,z])
  return(as.data.frame(y))
}

new_table2<-translate1(x,'c("M", "K", "J", "L", "I")')
