import re 
import requests 
from bs4 import BeautifulSoup as BS 
import pandas as pd
#from lxml import html
#Request to get information from weather underground
#req = requests.get('https://www.wunderground.com/forecast/us/nc/charlotte/KCLT?cm_ven=localwx_10day')


#request to get weather data from forecast.weather.gov
r = requests.get('https://forecast.weather.gov/MapClick.php?lat=36.2051&lon=-81.6658&lg=english&&FcstType=digitalDWML')

#Parsing as HTML
soup = BS(r.text,features = 'html.parser')
#print(soup.prettify())

#finding and storing the necessary raw information

#date by the hour
date = soup.find('time-layout').find_all('start-valid-time')


HI = soup.find('temperature', type = re.compile('heat index'))

#hourly temperature
hourly_temp = soup.find('temperature', type = 'hourly')

#wind direction in degrees
wind = soup.find('direction', type = 'wind')

#precipitation by the hour
hourly_precip = soup.find('hourly-qpf')

WeatherData = pd.DataFrame([list(date)])
WeatherData = WeatherData.append([list(HI)])
WeatherData = WeatherData.append([list(hourly_temp)])
WeatherData = WeatherData.append([list(hourly_precip)])
WeatherData = WeatherData.append([list(wind)])

tidyWeather = WeatherData.transpose()
tidyWeather.columns = ['DateTime','Heat Index', 'HrlyTemp', 'HrlyPrecip', 'Wind']

print(WeatherData[7])
print(tidyWeather[0:6])
