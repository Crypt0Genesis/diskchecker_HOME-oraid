#!/bin/bash

# Check disk usage for /dev/ partitions
dev_disk_usage=$(df -h | grep '/dev/' | awk '{ print $5 }' | sed 's/%//')

# Check disk usage specifically for /dev/sda* partition
sda_disk_usage=$(df -h | grep '/dev/sda*' | awk '{ print $5 }' | sed 's/%//')

# Combine the values, assuming that both partitions may exist
disk_usage=$(echo "$dev_disk_usage $sda_disk_usage" | tr '\n' ' ')

# Check if disk usage is greater than or equal to 80%
for usage in $disk_usage; do
    if [ -n "$usage" ] && [ "$usage" -ge 80 ]; then
        echo "Disk space is at $usage%. Running script..."

        # Add your script logic here
        /$HOME/diskcecker_HOME-oraid/disk-space-script.sh
        exit 0  # Exit after running the script once
    fi
done

echo "Disk space is below 80%. No action required."
