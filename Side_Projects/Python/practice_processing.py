#Python 3.8.2
#This script is to focus on using the csv and file tools to process data without needing to use a majority of the RAM.
#First will probably need to grab a large data set
#And also import a couple of things

import pandas as pd
import csv
import os
from bs4 import BeautifulSoup
from selenium import webdriver

geckodriver = r'/home/lawshx/Downloads/geckodriver'
options = webdriver.FirefoxOptions()
options.add_argument('-headless')
browser = webdriver.Firefox(executable_path=geckodriver, firefox_options=options)

url = 'https://www.wunderground.com/forecast/us/va/ashburn/KVALEESB156'

browser.get(url)

ps = browser.page_source #download the page source so that the browser can be closed

browser.close()


def extraction(tag,attribute, value):
	s = soup.find_all(tag, {attribute:value})
	return [x.text for x in s]

temp_hi = extraction('span', 'class', 'temp-hi')
temp_lo = extraction('span', 'class', 'temp-lo')
precip = extraction('span', '_ngcontent-app-root-c235', '')

p = [i for i in precip if re.search('(\d){1,2}.?(\d){0,2} in$', i)]


os.chdir(r'/home/lawshx/Downloads') 
