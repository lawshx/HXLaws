import re 
import requests 
from bs4 import BeautifulSoup as BS 
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

#printing values without tags
print(list(hourly_precip)[8].get_text())
#print(list(date)[8].get_text())
print(len(list(hourly_temp)))
#print(len(list(date)))
print(len(list(hourly_temp)))
#print(list(date)[0].extract().get_text())
#print(list(date)[1].extract().get_text())
#print(list(date)[2].extract().get_text())
#print(list(date)[3].extract().get_text())
#print(list(date)[4].extract().get_text())
#print(list(date)[659].extract().get_text())
print(len(date))
