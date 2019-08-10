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
#path = 'C:\\Users\\lawsh\\Downloads\\geckodriver-v0.24.0-win64\\geckodriver'
path = ''

#This is to ensure the location of the final CSV file
#filepath = 'C:\\Users\\lawsh\\Downloads\\WeatherData.csv'
filepath = '~\GitHub\HXLaws\Side_Projects\WeatherData.csv'

#using Firefox as browser
#To speed up browser, manually stop page load after all needed information is loaded.

#First set page loading strategy to none so that it can be set manually.
capa = DesiredCapabilities.FIREFOX
capa["pageLoadStrategy"] = "none"

#define the page load strategy and driver path while setting up browser.
#browser = webdriver.Firefox(desired_capabilities=capa, executable_path= path)
browser = webdriver.Firefox(desired_capabilities=capa)
##browser = webdriver.Firefox(executable_path = path)

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
        wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, 'html.js.flexbox.flexboxlegacy.canvas.canvastext.webgl.touch.geolocation.postmessage.no-websqldatabase.indexeddb.hashchange.history.draganddrop.websockets.rgba.hsla.multiplebgs.backgroundsize.borderimage.borderradius.boxshadow.textshadow.opacity.cssanimations.csscolumns.cssgradients.no-cssreflections.csstransforms.csstransforms3d.csstransitions.fontface.generatedcontent.video.audio.localstorage.sessionstorage.webworkers.applicationcache.svg.inlinesvg.smil.svgclippaths body.omnibus.page app city-tenday city-tenday-layout div.content-wrap.right-side-nav div#inner-wrap section#inner-content.inner-content.mast-wrap div.city-body div.row.city-forecast div.small-12.columns.has-sidebar div.row div.small-12.columns div.region-content-forecast city-tenday-forecast div.row forecast-graph div.weather-graph div.plots.has-header forecast-graph-plot div.plot-wrap div.plot.n0.plot-header div.flot-header')))

        #stop browser from loading further.
        browser.execute_script("window.stop();")
        
        #obtain information on temperature and precipitaion
        Temps = browser.find_elements_by_css_selector('span.test-false.wu-unit.wu-unit-temperature')
        Precip = browser.find_elements_by_css_selector('span.wu-value.wu-value-to')

        #storing all values found in webscraper as a list.
        t = [x.text for x in Temps]
        p = [x.text for x in Precip]
        pp = []
        

        #Grabing values that are less than 15
        #Assuming that 15 inches of precipitation is a good threshold to not store an unwanted value.
        for i in range(len(Precip)):
            if p[i]=="":
                print("")
            elif float(p[i]) <= 15.0:
                print(float(p[i]))
                pp.append(float(p[i]))


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
        elif DOW < 4 and DOW >= 0:
            for i in range(1,5 - DOW):
                print(s[i])
                high.append(s[i][:2])
                low.append(s[i][-2:])
                precip.append(pp[i - 1])
    

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

