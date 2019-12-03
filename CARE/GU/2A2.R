#"2 A.2: 85% of studnets will take the ACT/SAT by the end of the 11th grade."
#only have ACT scores

library(sqldf) #import sql library to do sql commands

#practicing with this dataset first.
year4 <- read.csv("\\\\ustor.appstate.edu\\COB-Deans\\CARE\\Research Areas\\Education\\GEAR UP\\GU Data\\Processed\\GU Y4\\Flat Files\\Y4_Flat_File_2019_07_02.csv")

year5 <-read.csv("\\\\ustor.appstate.edu\\COB-Deans\\CARE\\Research Areas\\Education\\GEAR UP\\GU Data\\Processed\\GU Y5\\Flat Files\\Y5_Flat_File_2019_08_15.csv")

#making script flexible to different flat files.
data = year5
Y = 'Y5'

#which column names are labelled specifically for year 4
#renaming these columns without the "Y4_" infront
c <- colnames(data)[grep(Y,colnames(data))]
colnames(data)[grep(Y,colnames(data))] <- substring(c,4,nchar(c))

data$District_ID <- gsub('unspecified', '000', data$District_ID)
data$District_ID <- gsub('Alleghany County', '030', data$District_ID)
data$District_ID <- gsub('Ashe County', '050', data$District_ID)
data$District_ID <- gsub('Burke County', '120', data$District_ID)
data$District_ID <- gsub('Clay County', '220', data$District_ID)
data$District_ID <- gsub('Graham County', '380', data$District_ID)
data$District_ID <- gsub('Madison County', '570', data$District_ID)
data$District_ID <- gsub('Rutherford County', '810', data$District_ID)
data$District_ID <- gsub('Swain County', '870', data$District_ID)
data$District_ID <- gsub('Watauga County', '950', data$District_ID)
data$District_ID <- gsub('Wilkes County', '970', data$District_ID)
data$District_ID <- gsub('Yancey County', '995', data$District_ID)


Grant <- c()
for (i in 1:length(data[,1])){
  if (data$District_ID[i] == '050'|data$District_ID[i] == '120'|data$District_ID[i] == '950'){
    Grant[i] <- 2
  } else if (data$District_ID[i] == '000'){
    Grant[i] <- 3 #even though there aren't 3 grants, I don't know what to do with District listed as unspecified
  } else {
    Grant[i] <- 1
  }
}



#coding in cohort code

data$cohort <- gsub('D 2016-17 Grade 6', '100', data$cohort)
data$cohort <- gsub('C 2015-16 Grade 6', '200', data$cohort)
data$cohort <- gsub('B 2014-15 Grade 6', '300', data$cohort)
data$cohort <- gsub('A 2014-15 Grade 7', '400', data$cohort)
data$cohort <- gsub('Control 2014-15 Grade 8', '500', data$cohort)
data$cohort <- gsub('D entered 1 yr late', '110', data$cohort)
data$cohort <- gsub('C entered 1 yr late', '210', data$cohort)
data$cohort <- gsub('B entered 1 yr late', '310', data$cohort)
data$cohort <- gsub('A entered 1 yr late', '410', data$cohort)
data$cohort <- gsub('Control entered 1 yr late', '510', data$cohort)
data$cohort <- gsub('D entered 2 yrs late', '120', data$cohort)
data$cohort <- gsub('C entered 2 yrs late', '220', data$cohort)
data$cohort <- gsub('B entered 2 yrs late', '320', data$cohort)
data$cohort <- gsub('A entered 2 yrs late', '420', data$cohort)
data$cohort <- gsub('Control entered 2 yrs late', '520', data$cohort)
data$cohort <- gsub('D entered 3 yrs late', '130', data$cohort)
data$cohort <- gsub('C entered 3 yrs late', '230', data$cohort)
data$cohort <- gsub('B entered 3 yrs late', '330', data$cohort)
data$cohort <- gsub('A entered 3 yrs late', '430', data$cohort)
data$cohort <- gsub('Control entered 3 yrs late', '530', data$cohort)
data$cohort <- gsub('D entered 4 yrs late', '140', data$cohort)
data$cohort <- gsub('C entered 4 yrs late', '240', data$cohort)
data$cohort <- gsub('B entered 4 yrs late', '340', data$cohort)
data$cohort <- gsub('A entered 4 yrs late', '440', data$cohort)
data$cohort <- gsub('Control entered 4 yrs late', '540', data$cohort)
data$cohort <- gsub('D entered 5 yrs late', '150', data$cohort)
data$cohort <- gsub('C entered 5 yrs late', '250', data$cohort)
data$cohort <- gsub('B entered 5 yrs late', '350', data$cohort)
data$cohort <- gsub('A entered 5 yrs late', '450', data$cohort)
data$cohort <- gsub('Control entered 5 yrs late', '550', data$cohort)
data$cohort <- gsub('D entered 6 yrs late', '160', data$cohort)
data$cohort <- gsub('C entered 6 yrs late', '260', data$cohort)
data$cohort <- gsub('B entered 6 yrs late', '360', data$cohort)
data$cohort <- gsub('A entered 6 yrs late', '460', data$cohort)
data$cohort <- gsub('Control entered 6 yrs late', '560', data$cohort)


#just seeing if there are multiple entries of students which would indicate whether there are more than one ACT/SAT score
#this SQL statement indicates that this is not the case, for now
GU_Students <- sqldf('SELECT DISTINCT(GU_ID), COUNT(*)
                      FROM data')

#this is a different way of testing the SQL statement.
#create a table of the GU ID's which indicates which ID's have more than one entry in the dataset
#make another table that finds whether there are GU ID's that appear more than one time
table((table(data$GU_ID)) > 1)

#total number of scores inside the year4 file. there's only 185 when there should be 2092 instances.
sum(table(data$ACT_Composite))

hist(data$ACT_Composite)
hist(data$ACT_Math)
hist(data$ACT_Science)
hist(data$ACT_English)
hist(data$ACT_Reading)

#These two were not able to create a histogram because there are no scores recorded
# hist(data$ACT_Writing)
# hist(data$ACT_STEM)

#identify which students did take the ACT.
ACT_taken <- sqldf('SELECT DISTINCT(GU_ID)
                    FROM data
                    WHERE ACT_Composite > 0')


#If else statement determining if PI is met.
ifelse((sum(table(data$ACT_Composite))/GU_Students[2]) >= 0.85,"85% did take the ACT/SAT by end of 11th grade", "criteria not met")
