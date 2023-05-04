
""" 
Python Script to generate a report for the past 24 hours
define: 
    cluster - Rubrik CDM IP or Cluster name
    api_token - secure token from CDM (username --> API Token manager within the UI)
    event_type - Select the type of events you want to see.
    before_date - Before date range. Format: 2022-08-05T18:30:00.000Z 
    after_date - After date range. Format: YYYY-MM-DDTHH:MM:SS.000Z
Once set use a cron or task scheduler to run this python script 
"""

# Import modules
import rubrik_cdm
import urllib3
import json
import os

# Disable certificate warnings and connect to Rubrik Cluster
urllib3.disable_warnings()

# Parameters used in the script
# Change these to your values 
cluster = "1X.3X.20.X"
api_token = "eyXXXXY"
#Type the event type for which you want to generate the log.
#Example: Archive, Backup, Audit, Diagnostic, Fileset, Hardware, HypervServer, Recovery, Replication, Storage, System etc
event_type = "Backup"
event_series_status = "SuccessWithWarnings"        

#DATE FORMAT EXAMPLE: "2022-08-05T18:30:00.000Z"   YYYY-MM-DDTHH:MM:SS.milisecondZ
beforeDate = "2023-04-25T18:30:00.000Z"               # From date (START DATE)
afterDate = "2023-04-29T18:30:00.000Z"                # To date (END DATE)

# connect to the cluster
rubrik=rubrik_cdm.Connect(cluster, api_token=api_token)

# current dateTime
from datetime import datetime,timedelta, date
date = datetime.today()-timedelta(days=1)

# convert to string
#date_time_str = date.strftime("%Y-%m-%dT%H:%M:%S")


# Find data

baseurl = '/event/csv_download_link?event_series_status={}&event_type={}&before_date={}&after_date={}'
url = baseurl.format(event_series_status, event_type, beforeDate, afterDate)
r = rubrik.get('v1', url)
t = json.dumps(r)
final = json.loads(t)
print ("Please copy and paste the following download link in your browser to download the file:")
print (final["downloadLink"])
