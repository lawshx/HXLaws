#Webscraping Weather Underground to gather high and low temperatures from specific weather stations.

import datetime #to find the date
import pandas #create dataframe from which to simply copy and paste into google sheets
from selenium import webdriver #webscraping tool to get to the webpages
from selenium.webdriver.common.keys import Keys #this is so that key shortcuts can be utilized

#must specify where the driver is to open browser
path = 'C:\\Users\\lawsh\\Downloads\\geckodriver-v0.24.0-win64\\geckodriver' 

#using Firefox as browser
browser = webdriver.Firefox(executable_path=path)
browser.get('https://www.google.com')



#These are the URLs for each of the 10-day forecasts of the requested weather stations
KCLT = 'https://www.wunderground.com/forecast/us/nc/charlotte/KCLT?cm_ven=localwx_10day'
KGSO = 'https://www.wunderground.com/forecast/KGSO?cm_ven=localwx_10day'
KRDU = 'https://www.wunderground.com/forecast/us/nc/morrisville/KRDU?cm_ven=localwx_10day'
KINT = 'https://www.wunderground.com/forecast/us/nc/winston-salem/KNCWINST59?cm_ven=localwx_10day'


#Get day of the week
DOW = datetime.datetime.today().weekday()

#creating list of weather station names
stations = ["KCLT","KGSO","KRDU","KINT"]
stations_links = [KCLT,KGSO,KRDU,KINT]

#Create dataframe with recorded temperatures
WeatherData = pandas.DataFrame([0],index = ["a"])

#Find all the parts of the webpage that may contain the high and low temperatures
for station in range(len(stations)):
    browser.find_element_by_tag_name('body').send_keys(Keys.COMMAND + 't') #open new tab in browser
    browser.get(stations_links[station])
    Temps = browser.find_elements_by_css_selector('span.test-false.wu-unit.wu-unit-temperature')
    Precip = browser.find_elements_by_css_selector('span.wu-value.wu-value-to')
    len(Precip)
    len(Temps)

    #storing all values found in webscraper as a list.
    t = [x.text for x in Temps]
    p = [x.text for x in Precip]
    

    pp = []

    for i in range(len(Precip)):
        if p[i]=="":
            print("nope")
        elif float(p[i]) <= 15.0:
            print(p[i])
            pp.append(p[i])
    #empty list to store non-empty values
    s = []

    #Looking through the list of values and finding those that have format "num | num"
    #Do this simply by finding "|" character
    for i in range(len(Temps)):
        if t[i].find('|') != -1:
            print(t[i])
            s.append(t[i][:7]) #[:7] will exclude the " F" in the string "88 | 70 F"



    #Creating empty lists to store high and low temperatures
    high = []
    low = []
    precip = []



    #If else statements to store the correct high and low temps depending on day of the week (DOW)
    #Only need temperatures for Mon,Tues,Wed,Thurs,Fri when DOW = 6 (Sunday)
    #Only need temperatures for Tues,Wed,Thurs,Fri when DOW = 0 (Monday)
    #and so on.
    if DOW == 6:
        for i in range(1,6):
            print(s[i])
            high.append(s[i][:2]) #grab first two characters in string (high temperature)
            low.append(s[i][-2:]) #grab last two characters in string (low temperature)
            precip.append(pp[i - 1])
    elif DOW == 0:
        for i in range(1,5):
            print(s[i])
            high.append(s[i][:2])
            low.append(s[i][-2:])
            precip.append(pp[i - 1])
    elif DOW == 1:
        for i in range(1,4):
            print(s[i])
            high.append(s[i][:2])
            low.append(s[i][-2:])
            precip.append(pp[i - 1])
    elif DOW == 2:
        for i in range(1,3):
            print(s[i])
            high.append(s[i][:2])
            low.append(s[i][-2:])
            precip.append(pp[i - 1])
    elif DOW == 1:
        for i in range(1,2):
            print(s[i])
            high.append(s[i][:2])
            low.append(s[i][-2:])
            precip.append(pp[i - 1])
    else:
        print("error:Weather recording not needed today. DOW is " + DOW) 



    
    #For easy naming convention each row is either the high or low temperatures for a specific weather station.
    WeatherData = WeatherData.append([high])
    WeatherData.rename(index = {0:stations[station] + '_H'}, inplace = True)
    WeatherData = WeatherData.append([low])
    WeatherData.rename(index = {0:stations[station] + '_L'}, inplace = True)
    WeatherData = WeatherData.append([precip])
    WeatherData.rename(index = {0:stations[station] + '_precip'}, inplace = True)
    WeatherData # double check that rows are named correctly
    browser.find_element_by_tag_name('body').send_keys(Keys.COMMAND + 'w') 

browser.close()
#exporting dataframe to a specific location
WeatherData.to_csv("C:\\Users\\lawsh\\Downloads\\WeatherData.csv")