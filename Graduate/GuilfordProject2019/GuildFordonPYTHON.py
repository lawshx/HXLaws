# -*- coding: utf-8 -*-
"""
Created on Tue Mar 12 17:16:53 2019

@author: H. X. Laws
"""
import os
os.getcwd()
import pandas as pd

file = "C:/Users/lawsh/Source/Repos/HXLaws/Graduate/GuilfordProject2019/callsForServiceUpdated.csv"

TheData = pd.read_csv(file, low_memory = False)
TheData.columns.values #understanding the colnames.

#Since the data in the cancelled and rptonly are seen as booleans, we subset all the data where the calls were not cancelled and are not reports.
NonCancelled = TheData[TheData["cancelled"]==False]
Desired_Data = NonCancelled[NonCancelled["rptonly"]==False]


#We already have an idea of what variables to focus on, so a new dataset is created to only focus on those.
Desired_Data = Desired_Data.rename(columns = {'calltime':'start_time','timeclose':'end_time'})
dd = Desired_Data[['start_time', 'end_time','agency', 'callsource', 'nature','lat', 'long', 'secs2rt','secs2di','secs2en','secs2ar','secs2tr','secs2lc','secsdi2en','secsdi2ar','secsar2tr','secsar2lc','secsrt2dsp','secstr2lc']]

#We need to convert start_time and end_time into expressions that can be converted into datetime format.
dd['start_time'].replace(to_replace = "T", value = r" ", regex = True, inplace = True)
dd['start_time'].replace(to_replace = "Z", value = r"", regex = True, inplace = True)

dd['end_time'].replace(to_replace = "T", value = r" ", regex = True, inplace = True)
dd['end_time'].replace(to_replace = "Z", value = r"", regex = True, inplace = True)
dd.head()

#converting start and end times into datetime format.
dd['start_time'] = pd.to_datetime(dd['start_time'])
dd['end_time'] = pd.to_datetime(dd['end_time'])

#creating new variable to determine how long a call takes.
dd['duration'] = (dd['end_time'] - dd['start_time']).astype('timedelta64[m]')

dd[dd['duration']<0] #find all durations < 0

for i in dd[dd['duration']<0]:
    a = dd['start_time']
    b = dd['end_time']

    dd['start_time'] = b
    dd['end_time'] = a
    dd['duration'] = (dd['end_time'] - dd['start_time']).astype('timedelta64[m]')
    print(dd['duration'])























