#!/bin/bash

# Check disk usage
disk_usage=$(df -h | grep '/dev/' | awk '{ print $5 }' | sed 's/%//')

# Check if disk usage is greater than or equal to 80%
if [ $disk_usage -ge 80 ]; then
	echo "Disk space is at $disk_usage%. Running script..."
 
	# Add your script logic here
	/$HOME/diskcecker_HOME-oraid/disk-space-script.sh
else
	echo "Disk space is below 80%. No action required."
fi
