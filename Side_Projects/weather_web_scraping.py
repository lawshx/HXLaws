#Webscraping Weather Underground to gather high and low temperatures from specific weather stations.

import datetime #to find the date
import pandas #create dataframe from which to simply copy and paste into google sheets
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import sys


#must specify where the driver is to open browser
path = 'C:\\Users\\lawsh\\Downloads\\Organize this\\geckodriver-v0.24.0-win64\\geckodriver.exe'
#path = '\usr\local\share\gecko driver\geckodriver.exe'

#This is to ensure the location of the final CSV file
filepath = 'C:\\Users\\lawsh\\Downloads\\WeatherData.csv'
#filepath = '~\GitHub\HXLaws\Side_Projects\WeatherData.csv'

#using Firefox as browser
#To speed up browser, manually stop page load after all needed information is loaded.

#First set page loading strategy to none so that it can be set manually.
capa = DesiredCapabilities.FIREFOX
capa["pageLoadStrategy"] = "none"

#define the page load strategy and driver path while setting up browser.
browser = webdriver.Firefox(desired_capabilities=capa, executable_path= path)
#browser = webdriver.Firefox(desired_capabilities=capa)

#tell the driver to wait for 20 seconds to load desired information.
#the next steps to stop the page load will be in the for loop below.
wait = WebDriverWait(browser, 20)


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
if DOW == 6 or (DOW < 4 and DOW >= 0):
    for station in range(len(stations)):
        #open browser to link inside .get().
        browser.maximize_window()
        browser.get(stations_links[station])
        
        #only wait for the page to load to the specific CSS header thing in ''s.
        wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, 'html body app-root app-tenday.ng-star-inserted one-column-layout wu-header sidenav.sidenav mat-sidenav-container.mat-drawer-container.mat-sidenav-container mat-sidenav-content.mat-drawer-content.mat-sidenav-content div#inner-wrap section#inner-content.inner-content div.region-content-main div.row div.small-12.columns.has-sidebar div.row div.small-12.columns lib-forecast-chart div.forecast-chart.adaptive div.charts-container.adaptive div.canvas-bounds div.charts-canvas div svg.chart.chart-even.first.pan-viewport svg g.pan-view svg rect.border')))

        #stop browser from loading further.
        browser.execute_script("window.stop();")
        
        #obtain information on temperature and precipitaion
        Temps_H = browser.find_elements_by_css_selector('span.temp-hi')
        Temps_L = browser.find_elements_by_css_selector('span.temp-lo')

        Precip = browser.find_elements_by_css_selector('div.obs-precip.ng-star-inserted')
        

        #storing all values found in webscraper as a list.
        t_h = [x.text for x in Temps_H]
        t_l = [x.text for x in Temps_L]
        p = [x.text for x in Precip]
        w = [x.text for x in Wind]
        
        #Creating empty lists for each of the recorded values.
        #These lists will be used to store the correct observations depending on the day of the week (DOW) variable.
        high = []
        low = []
        precip = []

          
        #If else statements to store the correct precipitation, high and low temps depending on day of the week (DOW)
        #Only need temperatures for Mon,Tues,Wed,Thurs,Fri when DOW = 6 (Sunday)
        #Only need temperatures for Tues,Wed,Thurs,Fri when DOW = 0 (Monday)
        #and so on.
        if DOW == 6:
            for i in range(1,6):
                print(t_h[i][:-1], t_l[i][:-1], float(p[i][:-3]))
                precip.append(p[i-1][:-3])
                high.append(t_h[i][:-1])
                low.append(t_l[i][:-1])
        elif DOW < 4 and DOW >= 0:
            for i in range(1,5 - DOW):
                print(t_h[i][:-1], t_l[i][:-1], float(p[i][:-3]))
                precip.append(p[i-1][:-3])
                high.append(t_h[i][:-1])
                low.append(t_l[i][:-1])
    

        #For easy naming convention each row is either the high or low temperatures for a specific weather station.
        WeatherData = WeatherData.append([high])
        WeatherData.rename(index = {0:stations[station] + '_H'}, inplace = True)
        WeatherData = WeatherData.append([low])
        WeatherData.rename(index = {0:stations[station] + '_L'}, inplace = True)
        WeatherData = WeatherData.append([precip])
        WeatherData.rename(index = {0:stations[station] + '_precip'}, inplace = True)
        WeatherData # double check that rows are named correctly
    
        #Creating new tab to open next web link.
        browser.execute_script('''window.open("about:blank", "_blank");''') #open new tab
        browser.switch_to_window(browser.window_handles[station + 1]) #switch to that new tab
else:
    print("Today is " + str(DOW))
    print("It is not a day to work.")

    
#close out all tabs and browser window
browser.quit() 

#exporting dataframe to a specific location
WeatherData.to_csv(filepath)


