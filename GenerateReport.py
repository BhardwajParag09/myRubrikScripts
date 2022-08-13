""" 
Python Script to generate a report for the past 24 hours
define: 
    cluster - Rubrik CDM IP or Cluster name
    api_token - secure token from CDM (username --> API Token manager within the UI)
    event_type - Select the type of events you want to see.
Once set use a cron or task scheduler to run this python script 
"""

# Import modules
import rubrik_cdm
import urllib3
import os

# Disable certificate warnings and connect to Rubrik Cluster
urllib3.disable_warnings()

# Parameters used in the script
# Change these to your values 
cluster = "X.X.X.X"
api_token = "XXXX"
#Type the event type for which you want to generate the log.
#Example: Archive, Backup, Audit, Diagnostic, Fileset, Hardware, HypervServer, Recovery, Replication, Storage, System etc
event_type = "Backup"

# connect to the cluster
rubrik=rubrik_cdm.Connect(cluster, api_token=api_token)


# current dateTime
from datetime import datetime,timedelta, date
date = datetime.today()-timedelta(days=1)

# convert to string
date_time_str = date.strftime("%Y-%m-%dT%H:%M:%S")


# Find archival data

baseurl = '/event/latest?event_status=Failure&event_type={}&before_date={}&limit=1'
url = baseurl.format(event_type, date_time_str)
r = rubrik.get('v1', url)
print(r)


