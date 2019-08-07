import requests
req = requests.get('https://www.wunderground.com/forecast/us/nc/charlotte/KCLT?cm_ven=localwx_10day')

from bs4 import BeautifulSoup as BS
soup = BS(req.text, features = "html.parser")
s = soup.find_all('script')
cdata = s[5]
print(cdata)
