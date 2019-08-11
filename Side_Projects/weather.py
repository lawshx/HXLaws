import re 
import requests 
from bs4 import BeautifulSoup as BS 
import pandas as pd
import types
#from lxml import html
#Request to get information from weather underground
#req = requests.get('https://www.wunderground.com/forecast/us/nc/charlotte/KCLT?cm_ven=localwx_10day')


#request to get weather data from forecast.weather.gov
#ALL data is hourly
r = requests.get('https://forecast.weather.gov/MapClick.php?lat=36.2051&lon=-81.6658&lg=english&&FcstType=digitalDWML')

#Parsing as HTML
soup = BS(r.text,features = 'html.parser')
#print(soup.prettify())

#finding and storing the necessary raw information

#date by the hour
date = soup.find('time-layout').select('start-valid-time')

#dew point
dew = soup.find('temperature', type = re.compile('dew point')).select('value')

#Heat Index 
HI = soup.find('temperature', type = re.compile('heat index')).select('value')

#hourly temperature
hourly_temp = soup.find('temperature', type = 'hourly').select('value')

#wind speed
wind_speed = soup.find('wind-speed', type = re.compile('sustained')).select('value')
#gusts wind speed 
wind_gust = soup.find('wind-speed', type = 'gust').select('value')

#wind direction in degrees
wind_dir = soup.find('direction').select('value')

#cloud amount in percentage
cloud = soup.find('cloud-amount', type = 'total').select('value')

#chance of precipitation
precip_pred = soup.find('probability-of-precipitation').select('value')

#percentage humidity
humidity = soup.find('humidity').select('value')

#precipitation by the hour in inches
hourly_precip = soup.find('hourly-qpf').select('value')

#weather condition: ie rain or thunderstorm
#needs a little more work to extract the weather-type
weather_cond = soup.find('weather').select('weather-conditions')

for i in range(len(weather_cond)):
    if type(weather_cond[25].value) == type(weather_cond[26].value):
        


(soup.find('weather').find_all('weather-conditions')[25]).find_all('value')[1]['weather-type']

#listing all the variables in a list
variables = [date, HI, weather_cond, hourly_temp, dew, precip_pred, hourly_precip, humidity, cloud, wind_gust, wind_speed, wind_dir]
for i in range(len(variables)):
    print(len(variables[i]))


#Going through each variable, replacing the value with the tags with the value WITHOUT the tags
for i in range(len(variables)):
    for j in range(len(variables[i])):
        a = (variables[i])[j]
        (variables[i])[j] = (variables[i])[j].get_text()


#Creating dataframe to store information
WeatherData = pd.DataFrame([date])
for i in range(1,len(variables)):
    WeatherData = WeatherData.append([variables[i]])


#transpose information so that it's every row is an observation
tidyWeather = WeatherData.transpose() 
#Changing column names
tidyWeather.columns = ['DateTime','Heat Index', 'WeatherCond', 'HrlyTemp', 'DewPt', 'PrecipPredict','HrlyPrecip', 'Humidity', 'CloudCover', 'WindGust', 'WindSpeed', 'WindDir']

#Testing out results
print(WeatherData[7])
print(tidyWeather[0:20])
