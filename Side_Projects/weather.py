import requests
req = requests.get('https://www.wunderground.com/forecast/us/nc/charlotte/KCLT?cm_ven=localwx_10day')

from bs4 import BeautifulSoup as BS
soup = BS(req.text, features = "html.parser")
s = soup.find_all('script')
cdata = s[5]
#print(cdata)

r = requests.get('https://forecast.weather.gov/MapClick.php?lat=36.2051&lon=-81.665&lg=english&&FcstType=digital')
print(r.text)
soup = BS(r.text,features = 'html.parser')
print(soup.option)
