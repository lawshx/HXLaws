#"2 A.2: 85% of studnets will take the ACT/SAT by the end of the 11th grade."
#only have ACT

library(sqldf) #import sql library to do sql commands

#practicing with this dataset first.
year4 <- read.csv("\\\\ustor.appstate.edu\\COB-Deans\\CARE\\Research Areas\\Education\\GEAR UP\\GU Data\\Processed\\GU Y4\\Flat Files\\Y4_Flat_File_2019_07_02.csv")

year5 <-read.csv("\\\\ustor.appstate.edu\\COB-Deans\\CARE\\Research Areas\\Education\\GEAR UP\\GU Data\\Processed\\GU Y5\\Flat Files\\Y5_Flat_File_2019_08_15.csv")

#making script flexible to different data sets.
data = year4
Y = 'Y4'


#which column names are labelled specifically for year 4
c <- colnames(data)[grep('Y4',colnames(data))]
substring(colnames(data)[grep('Y4',colnames(data))][1],4,nchar(colnames(data)[grep('Y4',colnames(data))][1]))

for (i in 1:length(c)) {
  c[i] <- substring(colnames(data)[grep('Y4',colnames(data))][i],4,nchar(colnames(data)[grep('Y4',colnames(data))][i]))
}

#reading strings as R commands
str_eval=function(x) {return(eval(parse(text=x)))}

#will need this to create the separate reports.
District_ID <- paste0('data$',Y,'_District_ID')

l <- data$Y4_District_ID

data$Y4_District_ID <- gsub('unspecified', '000', str_eval(District_ID))
District_ID <- gsub('Alleghany County', '030', District_ID)
District_ID <- gsub('Ashe County', '050', District_ID)
District_ID <- gsub('Burke County', '120', District_ID)
District_ID <- gsub('Clay County', '220', District_ID)
District_ID <- gsub('Graham County', '380', District_ID)
District_ID <- gsub('Madison County', '570', District_ID)
District_ID <- gsub('Rutherford County', '810', District_ID)
District_ID <- gsub('Swain County', '870', District_ID)
District_ID <- gsub('Watauga County', '950', District_ID)
District_ID <- gsub('Wilkes County', '970', District_ID)
District_ID <- gsub('Yancey County', '995', District_ID)


Grant <- c()
for (i in 1:length(data[,1])){
  if (District_ID[i] == '050'|District_ID[i] == '120'|District_ID[i] == '950'){
    Grant[i] <- 2
  } else if (District_ID[i] == '000'){
    Grant[i] <- 3 #even though there aren't 3 grants, I don't know what to do with District listed as unspecified
  } else {
    Grant[i] <- 1
  }
}



ACT_Composite <- paste0('data$',Y,'_ACT_Composite')
ACT_Math <- paste0('data$',Y,'_ACT_Math')
ACT_Science <- paste0('data$',Y,'_ACT_Science')
ACT_English <- paste0('data$',Y,'_ACT_English')
ACT_Reading <- paste0('data$',Y,'_ACT_Reading')
ACT_Writing <- paste0('data$',Y,'_ACT_Writing')
ACT_STEM <- paste0('data$',Y,'_ACT_STEM')


#just seeing if there are multiple entries of students which would indicate whether there are more than one ACT/SAT score
#this SQL statement indicates that this is not the case, for now
GU_Students <- sqldf('SELECT DISTINCT(GU_ID), COUNT(*)
       FROM data')

#this is a different way of testing the SQL statement.
#create a table of the GU ID's which indicates which ID's have more than one entry in the dataset
#make another table that finds whether there are GU ID's that appear more than one time
table((table(data$GU_ID))>1)

#total number of scores inside the year4 file. there's only 185 when there should be 2092 instances.
sum(table(str_eval(ACT_Composite)))

hist(str_eval(ACT_Composite))
hist(str_eval(ACT_Math))
hist(str_eval(ACT_Science))
hist(str_eval(ACT_English))
hist(str_eval(ACT_Reading))

#These two were not able to create a histogram because there are no scores recorded
# hist(str_eval())
# hist(data$Y4_ACT_STEM)

#identify which students did take the ACT.
ACT_taken <- sqldf('SELECT DISTINCT(GU_ID)
                    FROM data
                    WHERE Y4_ACT_Composite > 0')


#If else statement determining if PI is met.
ifelse((sum(table(data$Y4_ACT_Composite))/dim(data)[1]) >= 0.85,"85% did take the ACT/SAT by end of 11th grade", "criteria not met")
