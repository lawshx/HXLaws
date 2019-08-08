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
date = soup.find('time-layout')

HI = soup.find('temperature', type = re.compile('heat index'))
hourly_temp = soup.find('temperature', type = 'hourly')
wind = soup.find('direction', type = 'wind')
hourly_precip = soup.find('hourly-qpf')

#printing values without tags
print(list(hourly_precip)[8].get_text())
print(list(date)[8].get_text())
