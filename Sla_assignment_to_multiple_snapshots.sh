#!/bin/bash

########################################################################################################
# Title:    Sla_assignment_to_multiple_snapshots.sh
# Summary:  
#This script is used to assign a SLA to multiple objects at once.
#Usage: Create a file named name.txt containing the names of all the VMs which you want to change the SLA for. This can be used only with rubrik rksupport access
# Author:   Parag Bhardwaj
# USAGE: ./Sla_assignment_to_multiple_snapshots.sh
########################################################################################################

echo -e "The VM's list in file 'name.txt' contains the following objects which includes vmware_backup, fileset and volume group backups:"

object_id=$(IFS=$'\n' ;for i in `cat name.txt`; do cqlsh -ksd -e "select id, snappable_type from snappable where name= '$i'" | sed '/^$/d' | grep -v 'id\|+\|rows' | awk '{ gsub(/ /,""); print }' | awk -F '|' '{print $1}'; done)

object_sla=$(for i in $object_id; do cqlsh -ksd -e "select id, snappable_type, snappable_id, date from snapshot where snappable_id= '$i'" | grep -Ev "snappable|----|rows" | sed '/^$/d' | awk '{ gsub(/ /,""); print }'| awk -F'|' '{print $1" | "$4" | "$2":::"$3}'; done)
echo "$object_sla"

echo -e "  "

for i in $object_id; do cqlsh -ksd -e "select id, snappable_type, snappable_id from snapshot where snappable_id= '$i'" | grep -Ev "snappable|----|rows" | sed '/^$/d' | awk '{ gsub(/ /,""); print }'| awk -F'|' '{print $1"|"$2":::"$3}';done > snap.txt

cat snap.txt | while IFS='|' read i j ;do echo "for snapshot id: $i: and Object_id: $j"; rubrik_tool.py -X POST -V v2 "/sla_domain/assign_to_snapshot" -d "{ \"objectId\": \"${j}\", \"slaDomainId\": \"UNPROTECTED\", \"snapshotIds\": [ \"${i}\" ]}"; done
