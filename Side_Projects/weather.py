import requests
req = requests.get('https://www.wunderground.com/forecast/us/nc/charlotte/KCLT?cm_ven=localwx_10day')

from bs4 import BeautifulSoup as BS
from bs4 import CData
soup = BS(req.text, "xml")
s = soup.find_all('script')
cdata = s[5]
cdata