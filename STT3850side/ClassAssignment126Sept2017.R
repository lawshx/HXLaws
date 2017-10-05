library(ggplot2)
library(readxl)

DF <- read_excel("TMP.xlsx")

head(DF)

table(DF$Age_Cohort)

DF$Age_Cohort <- gsub("0 - 5", "0-5", DF$Age_Cohort)
DF$Age_Cohort <- gsub("42898", "6-12", DF$Age_Cohort)

table(DF$Age_Cohort)

aa <- subset(DF, Ethnicity == c("Hispanic", "White not Hispanic"))
aa$Age_Cohort <- factor(aa$Age_Cohort, levels=c("0-5", "6-12", "13-17", "18-21", "51 +"))

ggplot(aa, aes(x = Age_Cohort, fill = Ethnicity)) + 
  geom_bar(position = "dodge") +
  labs(title = "Consumers by Ethinicity and Age Cohort", x = "Age Cohort", y = "Number in Group")
  






#####################28Sept2017
#Dplyr
#1. summarize
#2. filter
#3. select
#4. arrange
#5. mutate

library("dpylr")

?ChickWeight
str(ChickWeight)
ChickWeight %>%
  group_by(Diet) %>%
  summarize(MWG = mean(weight), SD = sd(weight))






