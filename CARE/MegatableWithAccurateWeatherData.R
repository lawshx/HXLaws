library(haven)
library(sqldf)
megatable <- read_sas("C:/Users/lawsh/Downloads/SAS CERT/megatable.sas7bdat", 
                      NULL)
View(megatable)


#Testing SQL statement formatting.
sqldf('SELECT Type, COUNT(*)
        FROM megatable
        GROUP BY Type')

colnames(megatable)

#Remove the variables that will not be included in the new table
meg <- subset(megatable, select = -c(Year, Month, Day, Del, INV_NUMBER, SalesVolume, Price, Rent, Unit_Cost, Cost_Percent,
                                     Tot_Sls, Weekly_Rent_Estimate, Weekly_Rent_Cost_per_ItemWeek, Weekly_Labor_Estimate_by_Item,
                                     Store_County))

WithDescrip <-sqldf('
SELECT 
      
      DISTINCT(Weather_Station),
      Type,
      Description,
      Store_Num,
      County_Name,
      Date,      
      County_Labor_Force,
      County_Employed,
      County_Unemployed,
      County_Unemployment_Rate,
      Store_Name,
      Store_City,
      Store_State,
      Store_Location,
      Store_Drive_Through,
      Store_Near_School,
      Store_Competition_Fastfood,
      Store_Competition_Otherfood,
      Store_Traveller_Clients,
      Store_Minority_Clients,
      County_Total_Census_Pop,
      County_Non_Hispanic_White,
      County_Non_Hispanic_Black,
      County_Non_Hispanic_Native_Ameri,
      County_Non_Hispanic_Asian,
      County_Non_Hispanic_Pacific_Isla,
      County_Non_Hispanic_Two_or_more,
      County_Hispanic_White,
      County_Hispanic_Black,
      County_Hispanic_Native_American,
      County_Hispanic_Asian,
      County_Hispanic_Pacific_Islander,
      County_Hispanic_Two_or_more,
      County_Crime_Pop,
      County_Total_Crimes,
      County_Total_Crime_Rate,
      County_Violent_Crimes,
      County_Violent_Rate,
      County_Property_Crimes,
      County_Property_Rate,
      County_Society_Crimes,
      County_Society_Rate,
      County_Other_Crimes,
      County_Other_Rate,
      Avg_Wind,
      Precipitation,
      Avg_Snow,
      Avg_Snow_Depth,
      Avg_Max_Temp,
      Avg_Min_Temp,
      Weather_Days_Precipitated,
      Weather_Days_Snowed,
      Weather_Days_With_Snow_Accumulat,
      Weather_Days_With_Strong_Wind,
      Weather_Cold_Days,
      Weather_Bad_Weather_days,
      Weather_Bad_Weather_Week,
      SUM(Appended_Cost) AS APP_COST,
      SUM(Sold) AS SOLD,
      SUM(Sales) AS SALES,
      SUM(Cost) AS COST,
      SUM(Gross_Profit) AS GROSS_P,
      SUM(Adjusted_Profit) AS ADJ_P,
      SUM(Gross_Margin) AS GROSS_M,
      SUM(Adjusted_Margin) AS ADJ_M
      
      FROM meg
      WHERE Type = "Salad" AND Weather_Station = "Appleton Airport"
      GROUP BY Weather_Station, Description
      LIMIT 30')
#Checking that the calculation from above sql statement is correct
#The answer (according to the above query should be 40)
yy<-sqldf("
      SELECT Weather_Station, Description,Type, Sold
      FROM meg
      WHERE Description LIKE 'BLT SALAD' AND Weather_Station = 'Appleton Airport'
          ")

View(yy)#It adds up to 40! So the SQL query is calculating correctly.



#This is a version without the descriptions because I believe the descriptions will make it hard for the weather station data to be unique for each week of data. (Week want this to make reports without having SAS Viya calculating the information.)

NoDescrip <-sqldf('
SELECT 
           
           DISTINCT(Weather_Station),
           Type,
           Store_Num,
           County_Name,
           Date,      
           County_Labor_Force,
           County_Employed,
           County_Unemployed,
           County_Unemployment_Rate,
           Store_Name,
           Store_City,
           Store_State,
           Store_Location,
           Store_Drive_Through,
           Store_Near_School,
           Store_Competition_Fastfood,
           Store_Competition_Otherfood,
           Store_Traveller_Clients,
           Store_Minority_Clients,
           County_Total_Census_Pop,
           County_Non_Hispanic_White,
           County_Non_Hispanic_Black,
           County_Non_Hispanic_Native_Ameri,
           County_Non_Hispanic_Asian,
           County_Non_Hispanic_Pacific_Isla,
           County_Non_Hispanic_Two_or_more,
           County_Hispanic_White,
           County_Hispanic_Black,
           County_Hispanic_Native_American,
           County_Hispanic_Asian,
           County_Hispanic_Pacific_Islander,
           County_Hispanic_Two_or_more,
           County_Crime_Pop,
           County_Total_Crimes,
           County_Total_Crime_Rate,
           County_Violent_Crimes,
           County_Violent_Rate,
           County_Property_Crimes,
           County_Property_Rate,
           County_Society_Crimes,
           County_Society_Rate,
           County_Other_Crimes,
           County_Other_Rate,
           Avg_Wind,
           Precipitation,
           Avg_Snow,
           Avg_Snow_Depth,
           Avg_Max_Temp,
           Avg_Min_Temp,
           Weather_Days_Precipitated,
           Weather_Days_Snowed,
           Weather_Days_With_Snow_Accumulat,
           Weather_Days_With_Strong_Wind,
           Weather_Cold_Days,
           Weather_Bad_Weather_days,
           Weather_Bad_Weather_Week,
           SUM(Appended_Cost) AS APP_COST,
           SUM(Sold) AS SOLD,
           SUM(Sales) AS SALES,
           SUM(Cost) AS COST,
           SUM(Gross_Profit) AS GROSS_P,
           SUM(Adjusted_Profit) AS ADJ_P,
           SUM(Gross_Margin) AS GROSS_M,
           SUM(Adjusted_Margin) AS ADJ_M
           
           FROM meg
           WHERE Type = "Salad" AND Weather_Station = "Appleton Airport"
           GROUP BY Weather_Station, Description
           LIMIT 30')

write.csv(NoDescrip,file = "C:\\Users\\lawsh\\Downloads\\NoDescription.csv")
write.csv(WithDescrip,file = "C:\\Users\\lawsh\\Downloads\\WithDescription.csv")


